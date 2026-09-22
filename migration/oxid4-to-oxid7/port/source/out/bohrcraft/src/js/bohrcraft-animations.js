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

  initializeJumpToTop();\n\n  if (window.bootstrap?.Carousel) initializeCarousels();
  else window.addEventListener("load", initializeCarousels, {once: true});
})();
