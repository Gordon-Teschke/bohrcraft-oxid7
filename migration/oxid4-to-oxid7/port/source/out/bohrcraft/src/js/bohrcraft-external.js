(() => {
"use strict";
const cookieName="oxomiconsent";
const getCookie=(name)=>document.cookie.split("; ").find((row)=>row.startsWith(name+"="))?.split("=")[1]||"";
const setConsent=(value)=>{document.cookie=cookieName+"="+value+"; path=/; max-age=31536000; SameSite=Lax";};
const panel=document.querySelector("#bohrcraft-external-consent");
document.querySelector("[data-consent-save]")?.addEventListener("click",()=>{setConsent(document.querySelector("#bohrcraft-oxomi-consent")?.checked?"1":"0");window.location.reload();});
document.querySelector("[data-consent-reject]")?.addEventListener("click",()=>{setConsent("0");panel?.remove();});
document.querySelectorAll("[data-consent-settings]").forEach((button)=>button.addEventListener("click",()=>{document.cookie=cookieName+"=; path=/; max-age=0; SameSite=Lax";window.location.reload();}));
const loadFrame=(container)=>{const url=container?.dataset.externalSrc;if(!url||container.querySelector("iframe"))return;const frame=document.createElement("iframe");frame.src=url;frame.title=container.dataset.externalProvider==="map"?"Google Maps":"YouTube video";frame.loading="lazy";frame.referrerPolicy="strict-origin-when-cross-origin";frame.allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share";frame.allowFullscreen=true;frame.className="bohrcraft-external-frame";container.replaceChildren(frame);container.classList.add("is-loaded");};
document.querySelectorAll('[data-load-external="youtube"],[data-load-external="map"]').forEach((button)=>button.addEventListener("click",()=>loadFrame(button.closest(".bohrcraft-external"))));
let oxomiLoading=false;
const loadOxomi=(container)=>{if(!container||oxomiLoading||window.oxomi)return;oxomiLoading=true;setConsent("1");container.querySelector(".universal-search-grid")?.removeAttribute("hidden");container.querySelector("[data-load-external]")?.remove();
document.addEventListener("oxomi-loaded",()=>window.oxomi.init({portal:"3001715",language:container.dataset.language==="en"?"en":"de"}),{once:true});
document.addEventListener("oxomi-configured",()=>window.oxomi.universalSearch({target:"#universal-search-output",input:"#universal-search-input",lang:container.dataset.language==="en"?"en":"de",showActions:false,updatePortalUrl:true}),{once:true});
const script=document.createElement("script");script.src="https://oxomi.com/assets/frontend/v2/oxomi.js";script.async=true;script.onerror=()=>{oxomiLoading=false;container.insertAdjacentHTML("beforeend",'<p class="alert alert-warning mt-3">OXOMI could not be loaded.</p>');};document.head.appendChild(script);};
document.querySelectorAll(".bohrcraft-oxomi").forEach((container)=>{container.querySelector('[data-load-external="oxomi"]')?.addEventListener("click",()=>loadOxomi(container));if(getCookie(cookieName)==="1")loadOxomi(container);});
})();
