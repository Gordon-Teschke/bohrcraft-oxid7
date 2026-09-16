(() => {
  "use strict";
  if (window.__bohrcraftMotionReady) return;
  window.__bohrcraftMotionReady = true;
  const reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  document.querySelectorAll(".promoslider .carousel").forEach((element) => {
    if (!window.bootstrap?.Carousel) return;
    const carousel = window.bootstrap.Carousel.getOrCreateInstance(element, {
      interval: reduceMotion ? false : 5500,
      pause: "hover",
      ride: reduceMotion ? false : "carousel",
      touch: true,
      wrap: true
    });
    if (!reduceMotion) carousel.cycle();
  });
})();
