#!/usr/bin/env bash
set -Eeuo pipefail

# Bohrcraft OXID 7 deployment helper for Linux
#
# Safe defaults:
# - Does NOT modify shop data.
# - Creates code backups before replacing theme/module files.
# - Requires an explicit MySQL login-path for DB backup unless --skip-db-backup is used.
# - Preserves existing composer.json autoload entries and only adds/updates
#   Bohrcraft\Contact\ => modules/bohrcraft/contact/src/
# - Never uses chmod 777.

SHOP_ROOT="/var/www/www.bohrcraft.de/httpdocs-oxid7/bohrcraft"
PACKAGE_ROOT=""
PHP_BIN="php"
COMPOSER_PHAR="/var/www/www.bohrcraft.de/composerphar/composer_v2_9.phar"
MYSQLDUMP_BIN="mysqldump"
MYSQL_LOGIN_PATH="${MYSQL_LOGIN_PATH:-}"
DB_NAME=""
BASE_URL=""
SKIP_DB_BACKUP=0
SKIP_CODE_BACKUP=0
SKIP_COPY=0
SKIP_CHOWN=0
SHOP_ID="1"
RUNTIME_USER="www-data"
RUNTIME_GROUP="www-data"
BACKUP_ROOT=""
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
SMOKE_PATHS=("/" "/de/Marken/" "/de/Produkte/Spiralbohrer/" "/de/Unternehmen/Profil/" "/Company/Company-profile/" "/kontakt/")

log()  { printf '\033[1;34m[INFO]\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m[ OK ]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[WARN]\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31m[FAIL]\033[0m %s\n' "$*" >&2; exit 1; }

usage() {
  cat <<'EOF'
Bohrcraft OXID 7 Linux deployment helper

Options:
  --shop-root PATH          OXID project root.
                            Default:
                            /var/www/www.bohrcraft.de/httpdocs-oxid7/bohrcraft

  --package-root PATH       Optional deployment source with this structure:
                              source/Application/views/bohrcraft/
                              source/out/bohrcraft/
                              modules/bohrcraft/contact/
                            If omitted, existing runtime files are only verified.

  --php PATH                PHP CLI binary. Default: php
  --composer-phar PATH      Composer PHAR. Default:
                            /var/www/www.bohrcraft.de/composerphar/composer_v2_9.phar
  --mysqldump PATH          mysqldump binary. Default: mysqldump

  --mysql-login-path NAME   MySQL login-path used for mysqldump.
  --db-name NAME            DB schema to back up.
                            If omitted, the script tries source/config.inc.php.

  --skip-db-backup          Explicitly skip the DB backup.
  --skip-code-backup        Skip code tar backup. Not recommended.
  --skip-copy               Never copy package files.
  --skip-chown              Do not normalize owner/group after copy.

  --shop-id N               OXID shop id. Default: 1
  --runtime-user USER       Web/PHP runtime user. Default: www-data
  --runtime-group GROUP     Web/PHP runtime group. Default: www-data
  --url URL                 Optional public/staging URL for HTTP smoke tests.
  --smoke-path PATH         Replace default smoke paths with PATH; can be repeated.

  -h, --help                Show this help.

Environment:
  MYSQL_LOGIN_PATH          Alternative to --mysql-login-path.

Notes:
  - This script never restores a DB automatically.
  - Existing composer.json autoload settings are preserved.
  - The script stops on the first failed deployment step.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --shop-root) SHOP_ROOT="$2"; shift 2 ;;
    --package-root) PACKAGE_ROOT="$2"; shift 2 ;;
    --php) PHP_BIN="$2"; shift 2 ;;
    --composer-phar) COMPOSER_PHAR="$2"; shift 2 ;;
    --mysqldump) MYSQLDUMP_BIN="$2"; shift 2 ;;
    --mysql-login-path) MYSQL_LOGIN_PATH="$2"; shift 2 ;;
    --db-name) DB_NAME="$2"; shift 2 ;;
    --skip-db-backup) SKIP_DB_BACKUP=1; shift ;;
    --skip-code-backup) SKIP_CODE_BACKUP=1; shift ;;
    --skip-copy) SKIP_COPY=1; shift ;;
    --skip-chown) SKIP_CHOWN=1; shift ;;
    --shop-id) SHOP_ID="$2"; shift 2 ;;
    --runtime-user) RUNTIME_USER="$2"; shift 2 ;;
    --runtime-group) RUNTIME_GROUP="$2"; shift 2 ;;
    --url) BASE_URL="${2%/}"; shift 2 ;;
    --smoke-path)
      if [[ "${SMOKE_PATHS_CUSTOM:-0}" -eq 0 ]]; then
        SMOKE_PATHS=()
        SMOKE_PATHS_CUSTOM=1
      fi
      SMOKE_PATHS+=("$2")
      shift 2
      ;;
    -h|--help) usage; exit 0 ;;
    *) die "Unknown option: $1" ;;
  esac
done

SHOP_ROOT="${SHOP_ROOT%/}"
SOURCE_ROOT="$SHOP_ROOT/source"
THEME_TARGET="$SOURCE_ROOT/Application/views/bohrcraft"
OUT_TARGET="$SOURCE_ROOT/out/bohrcraft"
MODULE_TARGET="$SHOP_ROOT/modules/bohrcraft/contact"
COMPOSER_JSON="$SHOP_ROOT/composer.json"
OE_CONSOLE="$SHOP_ROOT/vendor/bin/oe-console"
MODULE_CONFIG="$SHOP_ROOT/var/configuration/shops/$SHOP_ID/modules/bohrcraft_contact.yaml"
MODULE_PUBLIC_LINK="$SOURCE_ROOT/out/modules/bohrcraft_contact"
BACKUP_ROOT="${BACKUP_ROOT:-$SHOP_ROOT/../deploy-backups/bohrcraft-$TIMESTAMP}"

on_error() {
  local exit_code=$?
  printf '\n'
  warn "Deployment stopped with exit code $exit_code."
  if [[ -d "$BACKUP_ROOT" ]]; then
    warn "Backups are in: $BACKUP_ROOT"
  fi
  warn "No automatic database restore was performed."
  exit "$exit_code"
}
trap on_error ERR

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "Required command not found: $1"
}

discover_db_name() {
  local cfg="$SOURCE_ROOT/config.inc.php"
  [[ -f "$cfg" ]] || return 0
  sed -n "s/^[[:space:]]*\\\$this->dbName[[:space:]]*=[[:space:]]*['\"]\\([^'\"]*\\)['\"].*/\\1/p" "$cfg" | head -n 1
}

run_oe() {
  "$PHP_BIN" "$OE_CONSOLE" "$@"
}

normalize_runtime_tmp() {
  local runtime_tmp="$SOURCE_ROOT/tmp"
  mkdir -p "$runtime_tmp"

  if [[ "$(id -u)" -eq 0 ]] && id "$RUNTIME_USER" >/dev/null 2>&1 && getent group "$RUNTIME_GROUP" >/dev/null 2>&1; then
    chown -R "$RUNTIME_USER:$RUNTIME_GROUP" "$runtime_tmp"
    find "$runtime_tmp" -type d -exec chmod 775 {} +
    find "$runtime_tmp" -type f -exec chmod 664 {} +
    chmod 775 "$runtime_tmp"
  fi
}

http_smoke_test() {
  local url="$1"
  local code
  code="$(curl -k -L -sS -o /dev/null -w '%{http_code}' "$url")"
  if [[ "$code" =~ ^[23] ]]; then
    ok "HTTP $code $url"
  else
    die "HTTP smoke test failed: $code $url"
  fi
}

# Composer explicitly allows non-interactive root execution for this deployment script.
# This suppresses Composer's root/super-user confirmation prompt when the script is run via sudo.
export COMPOSER_ALLOW_SUPERUSER=1

printf '\n=== Bohrcraft OXID 7 deployment ===\n\n'

log "Shop root: $SHOP_ROOT"
log "Public source root: $SOURCE_ROOT"
log "Composer PHAR: $COMPOSER_PHAR"
[[ -n "$PACKAGE_ROOT" ]] && log "Package root: $PACKAGE_ROOT"

log "1/10 Preflight"

[[ -d "$SHOP_ROOT" ]] || die "Shop root does not exist: $SHOP_ROOT"
[[ -d "$SOURCE_ROOT" ]] || die "OXID source root does not exist: $SOURCE_ROOT"
[[ -f "$SOURCE_ROOT/index.php" ]] || die "source/index.php not found. Wrong shop root?"
[[ -f "$COMPOSER_JSON" ]] || die "composer.json not found: $COMPOSER_JSON"
[[ -f "$OE_CONSOLE" ]] || die "OXID console not found: $OE_CONSOLE"
[[ -d "$SHOP_ROOT/vendor" ]] || die "vendor/ is missing."

require_cmd "$PHP_BIN"
require_cmd tar
require_cmd sed

PHP_VERSION="$("$PHP_BIN" -r 'echo PHP_VERSION;')"
log "PHP CLI: $PHP_VERSION"

"$PHP_BIN" -r 'exit(version_compare(PHP_VERSION, "8.1.0", ">=") ? 0 : 1);' \
  || die "PHP >= 8.1 required."

[[ -f "$COMPOSER_PHAR" ]] || die "Composer PHAR not found: $COMPOSER_PHAR"
"$PHP_BIN" "$COMPOSER_PHAR" --version >/dev/null
ok "Preflight passed"

log "2/10 Verify deployment files"

if [[ -n "$PACKAGE_ROOT" && "$SKIP_COPY" -eq 0 ]]; then
  PACKAGE_ROOT="${PACKAGE_ROOT%/}"
  THEME_SOURCE="$PACKAGE_ROOT/source/Application/views/bohrcraft"
  OUT_SOURCE="$PACKAGE_ROOT/source/out/bohrcraft"
  MODULE_SOURCE="$PACKAGE_ROOT/modules/bohrcraft/contact"

  [[ -f "$THEME_SOURCE/theme.php" ]] || die "Package theme.php missing: $THEME_SOURCE/theme.php"
  [[ -d "$THEME_SOURCE/tpl" ]] || die "Package theme tpl/ missing."
  [[ -d "$OUT_SOURCE" ]] || die "Package theme assets missing: $OUT_SOURCE"
  [[ -f "$MODULE_SOURCE/metadata.php" ]] || die "Package module metadata.php missing."
  [[ -f "$MODULE_SOURCE/composer.json" ]] || die "Package module composer.json missing."
  [[ -f "$MODULE_SOURCE/src/Controller/ContactController.php" ]] || die "Package ContactController missing."
  [[ -f "$MODULE_SOURCE/src/Controller/CatalogController.php" ]] || die "Package CatalogController missing."
  ok "Package structure valid"
else
  [[ -f "$THEME_TARGET/theme.php" ]] || die "Runtime theme missing: $THEME_TARGET/theme.php"
  [[ -f "$MODULE_TARGET/metadata.php" ]] || die "Runtime module missing: $MODULE_TARGET/metadata.php"
  [[ -f "$MODULE_TARGET/src/Controller/ContactController.php" ]] || die "Runtime ContactController missing."
  ok "Runtime files present"
fi

log "3/10 Backups"

mkdir -p "$BACKUP_ROOT"

if [[ "$SKIP_CODE_BACKUP" -eq 0 ]]; then
  CODE_ARCHIVE="$BACKUP_ROOT/code-before.tar.gz"
  tar_items=()
  [[ -e "$THEME_TARGET" ]] && tar_items+=("source/Application/views/bohrcraft")
  [[ -e "$OUT_TARGET" ]] && tar_items+=("source/out/bohrcraft")
  [[ -e "$MODULE_TARGET" ]] && tar_items+=("modules/bohrcraft/contact")
  tar_items+=("composer.json")

  (
    cd "$SHOP_ROOT"
    tar -czf "$CODE_ARCHIVE" "${tar_items[@]}"
  )
  ok "Code backup: $CODE_ARCHIVE"
else
  warn "Code backup explicitly skipped"
fi

if [[ "$SKIP_DB_BACKUP" -eq 0 ]]; then
  require_cmd "$MYSQLDUMP_BIN"

  if [[ -z "$DB_NAME" ]]; then
    DB_NAME="$(discover_db_name || true)"
  fi
  [[ -n "$DB_NAME" ]] || die "Could not determine DB name. Use --db-name or --skip-db-backup."
  [[ -n "$MYSQL_LOGIN_PATH" ]] || die "DB backup requires --mysql-login-path NAME (or MYSQL_LOGIN_PATH), or use --skip-db-backup explicitly."

  DB_DUMP="$BACKUP_ROOT/${DB_NAME}_before.sql"
  log "Backing up DB '$DB_NAME' via MySQL login-path '$MYSQL_LOGIN_PATH'"
  "$MYSQLDUMP_BIN" \
    --login-path="$MYSQL_LOGIN_PATH" \
    --single-transaction \
    --routines \
    --triggers \
    --events \
    --default-character-set=utf8mb4 \
    "$DB_NAME" > "$DB_DUMP"

  [[ -s "$DB_DUMP" ]] || die "DB dump is empty: $DB_DUMP"
  gzip -f "$DB_DUMP"
  ok "DB backup: ${DB_DUMP}.gz"
else
  warn "DB backup explicitly skipped"
fi

log "4/10 Deploy files"

if [[ -n "$PACKAGE_ROOT" && "$SKIP_COPY" -eq 0 ]]; then
  rm -rf "$THEME_TARGET" "$OUT_TARGET" "$MODULE_TARGET"
  mkdir -p "$(dirname "$THEME_TARGET")" "$(dirname "$OUT_TARGET")" "$(dirname "$MODULE_TARGET")"

  cp -a "$THEME_SOURCE" "$THEME_TARGET"
  cp -a "$OUT_SOURCE" "$OUT_TARGET"
  cp -a "$MODULE_SOURCE" "$MODULE_TARGET"

  ok "Theme, assets and contact module copied"
else
  log "Copy step skipped; using existing runtime files"
fi

log "5/10 PHP syntax checks"

PHP_FILES=(
  "$THEME_TARGET/theme.php"
  "$MODULE_TARGET/metadata.php"
  "$MODULE_TARGET/src/Controller/ContactController.php"
  "$MODULE_TARGET/src/Controller/CatalogController.php"
)

for file in "${PHP_FILES[@]}"; do
  [[ -f "$file" ]] || die "Missing PHP file: $file"
  "$PHP_BIN" -l "$file" >/dev/null
  ok "PHP lint: ${file#$SHOP_ROOT/}"
done

log "6/10 Composer autoload"

cp -a "$COMPOSER_JSON" "$BACKUP_ROOT/composer.json.before"

"$PHP_BIN" -- "$COMPOSER_JSON" <<'PHP'
<?php
$file = $argv[1] ?? null;
if (!$file || !is_file($file)) {
    fwrite(STDERR, "composer.json not found\n");
    exit(1);
}

$data = json_decode(file_get_contents($file), true, 512, JSON_THROW_ON_ERROR);

if (!isset($data['autoload']) || !is_array($data['autoload'])) {
    $data['autoload'] = [];
}
if (!isset($data['autoload']['psr-4']) || !is_array($data['autoload']['psr-4'])) {
    $data['autoload']['psr-4'] = [];
}

$data['autoload']['psr-4']['Bohrcraft\\Contact\\'] = 'modules/bohrcraft/contact/src/';

file_put_contents(
    $file,
    json_encode(
        $data,
        JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE | JSON_THROW_ON_ERROR
    ) . PHP_EOL
);
PHP

(
  cd "$SHOP_ROOT"
  "$PHP_BIN" "$COMPOSER_PHAR" validate --no-check-publish >/dev/null || warn "composer validate reported warnings/errors; inspect composer.json."
  "$PHP_BIN" "$COMPOSER_PHAR" dump-autoload -o
)
ok "Composer autoload rebuilt without replacing unrelated autoload entries"

log "7/10 Ownership and runtime permissions"

if [[ "$SKIP_CHOWN" -eq 0 ]]; then
  if [[ "$(id -u)" -eq 0 ]]; then
    OWNER="$(stat -c '%U' "$SHOP_ROOT")"
    GROUP="$(stat -c '%G' "$SHOP_ROOT")"

    if [[ "$OWNER" == "UNKNOWN" || "$GROUP" == "UNKNOWN" ]]; then
      warn "Could not determine project owner/group; code ownership unchanged."
    else
      chown -R "$OWNER:$GROUP" "$THEME_TARGET" "$OUT_TARGET" "$MODULE_TARGET"
      chown "$OWNER:$GROUP" "$COMPOSER_JSON"
      ok "Code ownership normalized to $OWNER:$GROUP"
    fi

    # OXID/Twig runtime cache must remain writable by Apache/PHP.
    if id "$RUNTIME_USER" >/dev/null 2>&1 && getent group "$RUNTIME_GROUP" >/dev/null 2>&1; then
      normalize_runtime_tmp
      ok "Runtime tmp permissions: $RUNTIME_USER:$RUNTIME_GROUP, dirs 775, files 664"
    else
      warn "Runtime user/group not found: $RUNTIME_USER:$RUNTIME_GROUP"
      warn "source/tmp ownership was not changed."
    fi
  else
    warn "Not running as root, so chown/runtime permission normalization is skipped."
  fi
else
  warn "Ownership normalization explicitly skipped"
fi

log "8/10 OXID module"

mkdir -p "$SOURCE_ROOT/out/modules"

# OXID creates source/out/modules/bohrcraft_contact as a symlink to
# modules/bohrcraft/contact/assets during module installation.
# A previous/partial install can leave this link behind while the module
# configuration YAML is still missing. In that state oe:module:install aborts
# with "symlink(): File exists". Handle that state idempotently.
if [[ ! -f "$MODULE_CONFIG" ]] && { [[ -e "$MODULE_PUBLIC_LINK" ]] || [[ -L "$MODULE_PUBLIC_LINK" ]]; }; then
  if [[ -L "$MODULE_PUBLIC_LINK" ]]; then
    CURRENT_TARGET="$(readlink -f "$MODULE_PUBLIC_LINK" 2>/dev/null || true)"
    EXPECTED_TARGET="$(readlink -f "$MODULE_TARGET/assets" 2>/dev/null || true)"

    log "Found stale module symlink: $MODULE_PUBLIC_LINK"
    log "Current target : ${CURRENT_TARGET:-unknown}"
    log "Expected target: ${EXPECTED_TARGET:-unknown}"

    if [[ -n "$CURRENT_TARGET" && -n "$EXPECTED_TARGET" && "$CURRENT_TARGET" == "$EXPECTED_TARGET" ]]; then
      rm "$MODULE_PUBLIC_LINK"
      ok "Removed stale bohrcraft_contact symlink before installation"
    else
      STALE_BACKUP="$BACKUP_ROOT/bohrcraft_contact-public-link-stale"
      mv "$MODULE_PUBLIC_LINK" "$STALE_BACKUP"
      warn "Existing symlink pointed elsewhere and was moved to: $STALE_BACKUP"
    fi
  else
    STALE_BACKUP="$BACKUP_ROOT/bohrcraft_contact-public-dir-stale"
    mv "$MODULE_PUBLIC_LINK" "$STALE_BACKUP"
    warn "Existing non-symlink module output was moved to: $STALE_BACKUP"
  fi
fi

pushd "$SOURCE_ROOT/out/modules" >/dev/null

if [[ -f "$MODULE_CONFIG" ]]; then
  log "Module already installed; cycling activation"
  run_oe oe:module:deactivate bohrcraft_contact -n || true
else
  log "Installing bohrcraft_contact"
  run_oe oe:module:install "$MODULE_TARGET" -n
fi

run_oe oe:module:activate bohrcraft_contact -n
popd >/dev/null

[[ -L "$MODULE_PUBLIC_LINK" || -e "$MODULE_PUBLIC_LINK" ]] \
  || die "Module public assets link was not created: $MODULE_PUBLIC_LINK"

ok "bohrcraft_contact active"

log "9/10 Theme and cache"

pushd "$SHOP_ROOT" >/dev/null
run_oe oe:theme:activate bohrcraft -n
run_oe oe:cache:clear
popd >/dev/null

# OXID console commands executed as root can recreate container/Twig cache files
# owned by root. Normalize once more before Apache/PHP-FPM serves the shop.
if [[ "$SKIP_CHOWN" -eq 0 ]]; then
  normalize_runtime_tmp
  ok "Runtime tmp permissions re-normalized after OXID cache rebuild"
fi

ok "Theme bohrcraft activated and OXID cache cleared"

log "10/10 Final checks"

[[ -f "$MODULE_CONFIG" ]] || warn "Module config file not found at expected path: $MODULE_CONFIG"

if [[ -n "$BASE_URL" ]]; then
  require_cmd curl
  for path in "${SMOKE_PATHS[@]}"; do
    [[ "$path" == /* ]] || path="/$path"
    http_smoke_test "${BASE_URL}${path}"
  done
else
  warn "No --url supplied; HTTP smoke test skipped."
fi

printf '\n'
ok "Deployment completed successfully."
printf '\nSummary:\n'
printf '  Shop root : %s\n' "$SHOP_ROOT"
printf '  Theme     : bohrcraft\n'
printf '  Module    : bohrcraft_contact\n'
printf '  Runtime    : %s:%s (source/tmp)\n' "$RUNTIME_USER" "$RUNTIME_GROUP"
printf '  Backup    : %s\n' "$BACKUP_ROOT"
[[ -n "$BASE_URL" ]] && printf '  URL        : %s\n' "$BASE_URL"

printf '\nRecommended manual checks:\n'
printf '  - Start page DE/EN\n'
printf '  - Navigation / mobile navigation\n'
printf '  - Contact form and catalog request\n'
printf '  - YouTube consent\n'
printf '  - OXOMI consent/content\n'
printf '  - Google Maps click-to-load\n'
printf '  - Downloads / PDFs\n'
printf '  - Apache/PHP/OXID logs\n'
