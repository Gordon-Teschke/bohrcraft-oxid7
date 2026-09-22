(() => {
  "use strict";
  if (window.__bohrcraftMotionReady) return;
  window.__bohrcraftMotionReady = true;


  const initializeJumpToTop = () => {
    const button = document.querySelector("#jumptotop");
    if (!button) return;

    const update = () => {
      button.classList.toggle("show", window.scrollY > 250);
    };

    button.addEventListener("click", () => {
      window.scrollTo({top: 0, behavior: "smooth"});
    });

    window.addEventListener("scroll", update, {passive: true});
    update();
  };

  const initializeHomeFinalTiles = () => {
    const home = document.querySelector(".bohrcraft-home");
    if (!home) return;

    const trigger = [...home.querySelectorAll("a")].find((link) => {
      const label = link.textContent.trim().toLowerCase();
      const href = (link.getAttribute("href") || "").toLowerCase();
      return label === "neuheiten"
        || label === "innovations"
        || href.includes("downloads-browse-online-news");
    });

    const container = trigger?.closest(".panel1container");
    if (container) {
      container.classList.add("bc-home-final-tiles");
      return;
    }

    const panels = home.querySelectorAll(".panel1container");
    panels[panels.length - 1]?.classList.add("bc-home-final-tiles");
  };

  const initializeCarousels = () => {
    if (!window.bootstrap?.Carousel) return;
    const reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
    document.querySelectorAll(".promoslider .carousel").forEach((element) => {
      const carousel = window.bootstrap.Carousel.getOrCreateInstance(element, {
        interval: reduceMotion ? false : 7000,
        pause: false,
        ride: reduceMotion ? false : "carousel",
        touch: true,
        wrap: true
      });
      if (!reduceMotion) carousel.cycle();
    });
  };

  initializeJumpToTop();
  initializeHomeFinalTiles();

  if (window.bootstrap?.Carousel) initializeCarousels();
  else window.addEventListener("load", initializeCarousels, {once: true});
})();
