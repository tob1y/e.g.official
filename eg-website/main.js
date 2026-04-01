(function () {
  var toggle = document.querySelector(".nav-toggle");
  var nav = document.querySelector("#site-nav");
  if (toggle && nav) {
    toggle.addEventListener("click", function () {
      var open = nav.classList.toggle("is-open");
      toggle.setAttribute("aria-expanded", open ? "true" : "false");
    });

    nav.querySelectorAll("a").forEach(function (link) {
      link.addEventListener("click", function () {
        nav.classList.remove("is-open");
        toggle.setAttribute("aria-expanded", "false");
      });
    });
  }

  /** 故事图：探测目录 base + 真实扩展名（含误存的 .png.jpg） */
  function stemFromStorySrc(src) {
    var m = String(src || "").replace(/\\/g, "/").match(/([^/]+)\.png$/i);
    return m ? m[1] : "";
  }

  function pickStoryImageBase(cb) {
    var story = document.querySelector('[data-carousel-name="story"]');
    if (!story) {
      cb(null);
      return;
    }
    var imgs = Array.prototype.slice.call(story.querySelectorAll("img"));
    if (!imgs.length) {
      cb(null);
      return;
    }

    var firstStem = stemFromStorySrc(imgs[0].getAttribute("src"));
    if (!firstStem) {
      cb(null);
      return;
    }

    var bases = ["images/", "eg-website/images/"];
    var exts = [".png", ".png.jpg", ".jpg", ".jpeg", ".webp"];

    function tryAll(bi, ei) {
      if (bi >= bases.length) {
        cb(null);
        return;
      }
      if (ei >= exts.length) {
        tryAll(bi + 1, 0);
        return;
      }
      var probe = new Image();
      var url = bases[bi] + firstStem + exts[ei];
      probe.onload = function () {
        cb({ base: bases[bi], ext: exts[ei] });
      };
      probe.onerror = function () {
        tryAll(bi, ei + 1);
      };
      probe.src = url;
    }
    tryAll(0, 0);
  }

  function applyStoryImageBase(opts) {
    if (!opts || !opts.base || !opts.ext) return;
    var story = document.querySelector('[data-carousel-name="story"]');
    if (!story) return;
    story.querySelectorAll("img").forEach(function (img) {
      var stem = stemFromStorySrc(img.getAttribute("src"));
      if (stem) img.src = opts.base + stem + opts.ext;
    });
  }

  function initCarousels(root) {
    var carousels = root.querySelectorAll("[data-carousel]");
    carousels.forEach(function (el) {
      var track = el.querySelector("[data-carousel-track]");
      var slides = el.querySelectorAll("[data-carousel-slide]");
      var prev = el.querySelector("[data-carousel-prev]");
      var next = el.querySelector("[data-carousel-next]");
      var dotsContainer = el.querySelector("[data-carousel-dots]");
      var live = el.querySelector("[data-carousel-live]");
      if (!track || !slides.length || !prev || !next || !dotsContainer) return;

      var n = slides.length;
      var i = 0;
      var dots = [];

      function go(idx) {
        i = ((idx % n) + n) % n;
        track.style.transform = "translateX(-" + i * 100 + "%)";
        slides.forEach(function (s, j) {
          s.setAttribute("aria-hidden", j === i ? "false" : "true");
        });
        dots.forEach(function (d, j) {
          d.classList.toggle("is-active", j === i);
        });
        if (live) {
          var cap = slides[i].querySelector("figcaption");
          var extra = slides[i].querySelector("[data-carousel-slide-title]");
          var t = extra ? extra.textContent.trim() : "";
          var c = cap ? cap.textContent.trim() : "";
          live.textContent = t ? t + (c ? " — " + c : "") : c;
        }
      }

      for (var d = 0; d < n; d++) {
        (function (idx) {
          var b = document.createElement("button");
          b.type = "button";
          b.className = "eg-carousel__dot";
          b.setAttribute("aria-label", "第 " + (idx + 1) + " 张，共 " + n + " 张");
          b.addEventListener("click", function () {
            go(idx);
          });
          dotsContainer.appendChild(b);
          dots.push(b);
        })(d);
      }

      prev.addEventListener("click", function () {
        go(i - 1);
      });
      next.addEventListener("click", function () {
        go(i + 1);
      });

      el.addEventListener("keydown", function (e) {
        if (e.key === "ArrowLeft") {
          e.preventDefault();
          go(i - 1);
        }
        if (e.key === "ArrowRight") {
          e.preventDefault();
          go(i + 1);
        }
      });

      go(0);
    });
  }

  var tip = document.getElementById("image-missing-tip");

  pickStoryImageBase(function (opts) {
    if (opts) {
      applyStoryImageBase(opts);
    } else if (tip) {
      tip.hidden = false;
    }
    initCarousels(document);
  });

  var storyCarousel = document.querySelector("[data-carousel][data-carousel-name='story']");
  if (storyCarousel && tip) {
    storyCarousel.querySelectorAll("img").forEach(function (img) {
      img.addEventListener("error", function () {
        tip.hidden = false;
      });
    });
  }
})();
