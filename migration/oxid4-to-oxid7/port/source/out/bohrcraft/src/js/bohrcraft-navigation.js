(() => {
  "use strict";
  if (window.__bohrcraftNavigationReady) return;
  window.__bohrcraftNavigationReady = true;

  const brandTemplate = document.querySelector("#bc-brand-menu-template");
  const brandLink = [...document.querySelectorAll("#navigation > .nav-item > .nav-link-1")].find((link) => /^(Marken|Brands)$/.test(link.textContent.trim()));
  if (brandTemplate && brandLink) {
    const brandItem = brandLink.closest(".nav-item");
    brandItem.classList.add("has-subs", "bc-brand-menu");
    brandItem.append(brandTemplate.content.cloneNode(true));
  }

  const desktop = window.matchMedia("(min-width: 992px)");
  const items = [...document.querySelectorAll("#navigation > .has-subs")];
  const closeAll = (except) => items.forEach((item) => {
    if (item !== except) {
      item.classList.remove("is-open");
      item.querySelector(":scope > .nav-link-1")?.setAttribute("aria-expanded", "false");
    }
  });

  items.forEach((item) => {
    const trigger = item.querySelector(":scope > .nav-link-1");
    const menu = item.querySelector(":scope > .nav-level-2");
    if (!trigger || !menu) return;
    trigger.setAttribute("aria-haspopup", "true");
    trigger.setAttribute("aria-expanded", "false");
    trigger.addEventListener("click", (event) => {
      if (desktop.matches) return;
      event.preventDefault();
      const open = !item.classList.contains("is-open");
      closeAll(item);
      item.classList.toggle("is-open", open);
      trigger.setAttribute("aria-expanded", String(open));
    });
  });

  document.addEventListener("click", (event) => {
    if (!event.target.closest("#mainnav")) closeAll();
  });
  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape") {
      closeAll();
      document.querySelector(".bc-menu-toggle[aria-expanded=true]")?.click();
    }
  });
  desktop.addEventListener?.("change", () => closeAll());

  const headerMain = document.querySelector(".bc-header-main");
  if (headerMain && "IntersectionObserver" in window) {
    const observer = new IntersectionObserver(([entry]) => {
      document.body.classList.toggle("fixed-header", !entry.isIntersecting && entry.boundingClientRect.bottom < 0);
    }, {threshold: 0});
    observer.observe(headerMain);
  }
})();
