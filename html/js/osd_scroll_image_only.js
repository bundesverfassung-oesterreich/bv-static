const facsContainer = document.getElementById("container_facs_1");
const imageRights = document.getElementsByClassName("image_rights")[0];
const imageSourceNodes = Array.from(document.querySelectorAll(".image-source"));

const IIIF_IMAGE_SUFFIX = /\/full\/(?:full|max)\/0\/default\.(?:jpg|jpeg|png)(?:\?.*)?$/i;
const IIIF_BASE_ENDPOINT = /\/viewer\/api\/v1\/records\/[^/]+\/files\/images\/[^/?#]+\/?$/i;

function toIiifInfoUrl(imageUrl) {
  if (!imageUrl) {
    return "";
  }

  if (imageUrl.endsWith("/info.json")) {
    return imageUrl;
  }

  if (IIIF_IMAGE_SUFFIX.test(imageUrl)) {
    return imageUrl.replace(IIIF_IMAGE_SUFFIX, "") + "/info.json";
  }

  if (IIIF_BASE_ENDPOINT.test(imageUrl)) {
    const normalized = imageUrl.replace(/\/$/, "");
    if (/\.(?:tif|tiff|jp2|jpg|jpeg|png)$/i.test(normalized)) {
      return normalized + "/info.json";
    }
    return normalized + ".tif/info.json";
  }

  return imageUrl;
}

if (facsContainer && imageRights && imageSourceNodes.length > 0) {
  function calculateFacsContainerHeight() {
    // in fullscreen the container itself is the fullscreen element - fill the whole screen
    if (document.fullscreenElement) {
      return Math.round(window.innerHeight);
    }
    const imageRightsHeight = imageRights.getBoundingClientRect().height;
    const newContainerHeight =
      window.innerHeight - (window.innerHeight / 10 + imageRightsHeight);
    return Math.round(newContainerHeight);
  }

  function resizeFacsContainer() {
    facsContainer.style.height = `${String(calculateFacsContainerHeight())}px`;
  }

  const pageSources = imageSourceNodes.map((node) => {
    const imageUrl = node.dataset.imageUrl;
    return {
      imageUrl,
      tileSource: toIiifInfoUrl(imageUrl),
    };
  });

  const tileSources = pageSources.map((source) => source.tileSource);

  resizeFacsContainer();

  const viewer = new OpenSeadragon.Viewer({
    id: "container_facs_1",
    prefixUrl:
      "https://cdnjs.cloudflare.com/ajax/libs/openseadragon/4.1.0/images/",
    tileSources,
    visibilityRatio: 1,
    sequenceMode: true,
    showNavigationControl: true,
    showNavigator: false,
    showSequenceControl: true,
    showZoomControl: true,
    preload: true,
    constrainDuringPan: true,
    imageLoaderLimit: 3,
    timeout: 60000,
    tileRetryMax: 2,
    tileRetryDelay: 1500,
    preserveViewport: true,
  });

  function fitVerticallyCentered() {
    const tiledImage = viewer.world.getItemAt(viewer.world.getItemCount() - 1);

    if (!tiledImage) {
      return;
    }

    // Always fit to the real image bounds to avoid clipping edges.
    viewer.viewport.fitBounds(tiledImage.getBounds(), true);
    viewer.viewport.applyConstraints(true);
  }

  viewer.viewport.goHome = function () {
    fitVerticallyCentered();
  };

  /* The currently displayed view, stored as fractions of the displayed image
     (so it can be mapped onto the next image on load). */
  let savedImageView = null;

  // Remember which relative section of the currently shown image is displayed.
  function captureImageView() {
    const tiledImage = viewer.world.getItemAt(viewer.world.getItemCount() - 1);
    if (!tiledImage) {
      return;
    }
    const imageBounds = tiledImage.getBounds();
    const viewBounds = viewer.viewport.getBounds();
    savedImageView = {
      x: (viewBounds.x - imageBounds.x) / imageBounds.width,
      y: (viewBounds.y - imageBounds.y) / imageBounds.height,
      width: viewBounds.width / imageBounds.width,
      height: viewBounds.height / imageBounds.height,
    };
  }

  // Show the same relative section (and zoom) of the newly opened image; a plain
  // fit is only used while nothing was captured yet (initial load).
  function applyCapturedImageView() {
    const tiledImage = viewer.world.getItemAt(viewer.world.getItemCount() - 1);
    if (!tiledImage) {
      return;
    }
    if (!savedImageView) {
      fitVerticallyCentered();
      return;
    }
    const imageBounds = tiledImage.getBounds();
    const targetBounds = new OpenSeadragon.Rect(
      imageBounds.x + savedImageView.x * imageBounds.width,
      imageBounds.y + savedImageView.y * imageBounds.height,
      savedImageView.width * imageBounds.width,
      savedImageView.height * imageBounds.height
    );
    viewer.viewport.fitBounds(targetBounds, true);
    viewer.viewport.applyConstraints(true);
  }

  /* Capture the current view before every page change - all navigation (slider,
     custom buttons, OSD's built-in controls, keyboard) routes through goToPage. */
  const osdGoToPage = viewer.goToPage.bind(viewer);
  viewer.goToPage = (page) => {
    captureImageView();
    return osdGoToPage(page);
  };

  // OSD's default controls carry no class names - tag their container so CSS can
  // hide it in the normal layout and only reveal it in fullscreen
  facsContainer
    .querySelectorAll(".openseadragon-container > div")
    .forEach((el) => {
      if (el.querySelector("[title]")) {
        el.classList.add("osd-default-controls");
      }
    });

  // wire our custom control row (OSD's own controls are only shown in fullscreen mode)
  document.getElementById("osd_zoom_in_button").addEventListener("click", () => {
    viewer.viewport.zoomBy(1.5);
  });
  document.getElementById("osd_zoom_out_button").addEventListener("click", () => {
    viewer.viewport.zoomBy(1 / 1.5);
  });
  document.getElementById("osd_zoom_reset_button").addEventListener("click", () => {
    viewer.viewport.goHome();
  });
  document.getElementById("osd_fullscreen_button").addEventListener("click", () => {
    viewer.setFullScreen(!viewer.isFullPage());
  });

  /* OSD greys out buttons it has disabled (prev/next at sequence boundaries) -
     tag them so CSS can hide them in fullscreen instead of showing them greyed */
  function updateOsdDisabledButtons() {
    [viewer.previousButton, viewer.nextButton].forEach((button) => {
      if (button && button.element) {
        button.element.classList.toggle("osd-disabled", !!button.element.disabled);
      }
    });
  }
  [viewer.previousButton, viewer.nextButton].forEach((button) => {
    if (button && button.element) {
      new MutationObserver(updateOsdDisabledButtons).observe(button.element, {
        attributes: true,
        attributeFilter: ["style"],
      });
    }
  });
  updateOsdDisabledButtons();

  viewer.addHandler("open", () => {
    applyCapturedImageView();

    // Refit once after the image is fully loaded to avoid edge clipping.
    const tiledImage = viewer.world.getItemAt(viewer.world.getItemCount() - 1);
    if (tiledImage && typeof tiledImage.addOnceHandler === "function") {
      tiledImage.addOnceHandler("fully-loaded-change", applyCapturedImageView);
    }

    // Some browsers apply late layout changes shortly after load.
    setTimeout(applyCapturedImageView, 250);
  });

  // Ensure first image is fitted even if initial `open` fired before handler attachment.
  if (viewer.world.getItemCount() > 0) {
    fitVerticallyCentered();
    const initialTiledImage = viewer.world.getItemAt(viewer.world.getItemCount() - 1);
    if (initialTiledImage && typeof initialTiledImage.addOnceHandler === "function") {
      initialTiledImage.addOnceHandler("fully-loaded-change", fitVerticallyCentered);
    }
  }

  const warmedIiifInfo = new Set();

  function warmupNextIiifInfo(pageIndex) {
    const nextIndex = pageIndex + 1;
    if (nextIndex < 0 || nextIndex >= pageSources.length) {
      return;
    }

    const tileSourceUrl = pageSources[nextIndex].tileSource;
    if (!tileSourceUrl || !tileSourceUrl.endsWith("/info.json")) {
      return;
    }

    if (warmedIiifInfo.has(tileSourceUrl)) {
      return;
    }

    warmedIiifInfo.add(tileSourceUrl);
    fetch(tileSourceUrl, { cache: "force-cache" }).catch(() => {
      warmedIiifInfo.delete(tileSourceUrl);
    });
  }

  let currentPage = 0;
  const maxPage = tileSources.length - 1;
  const prev = document.getElementById("osd_prev_button");
  const next = document.getElementById("osd_next_button");
  const pageSlider = document.getElementById("osd_page_slider");
  const pageIndicator = document.getElementById("osd_page_indicator");
  let isDraggingPageSlider = false;

  function updatePageIndicator(pageIndex) {
    if (!pageIndicator) {
      return;
    }

    pageIndicator.textContent = `Seite ${pageIndex + 1} von ${maxPage + 1}`;
  }

  function updatePageSlider(pageIndex, syncThumb = true) {
    if (!pageSlider) {
      return;
    }

    pageSlider.max = String(maxPage);
    pageSlider.setAttribute("aria-valuenow", String(pageIndex + 1));
    pageSlider.setAttribute("aria-valuetext", `Seite ${pageIndex + 1} von ${maxPage + 1}`);
    pageSlider.setAttribute("aria-valuemax", String(maxPage + 1));
    updatePageIndicator(pageIndex);

    if (syncThumb) {
      pageSlider.value = String(pageIndex);
    }
  }

  function updateButtonState() {
    prev.style.opacity = currentPage === 0 ? 0.6 : 1;
    next.style.opacity = currentPage === maxPage ? 0.6 : 1;
  }

  if (pageSlider) {
    const startSliderDrag = () => {
      isDraggingPageSlider = true;
    };

    const stopSliderDrag = () => {
      isDraggingPageSlider = false;
      updatePageSlider(currentPage, true);
    };

    pageSlider.addEventListener("pointerdown", startSliderDrag);
    pageSlider.addEventListener("pointerup", stopSliderDrag);
    pageSlider.addEventListener("pointercancel", stopSliderDrag);
    pageSlider.addEventListener("blur", stopSliderDrag);

    pageSlider.addEventListener("input", (event) => {
      const sliderValue = Number.parseFloat(event.target.value);
      const targetPage = Math.max(0, Math.min(maxPage, Math.round(sliderValue)));

      if (Number.isNaN(targetPage) || targetPage === currentPage) {
        if (isDraggingPageSlider) {
          updatePageIndicator(targetPage);
        }
        return;
      }

      updatePageIndicator(targetPage);
      viewer.goToPage(targetPage);
    });
  }

  viewer.addHandler("page", (event) => {
    currentPage = event.page;
    updateButtonState();
    updatePageSlider(currentPage, !isDraggingPageSlider);
    warmupNextIiifInfo(currentPage);
  });

  prev.addEventListener("click", () => {
    if (currentPage <= 0) {
      return;
    }

    viewer.goToPage(currentPage - 1);
  });

  next.addEventListener("click", () => {
    if (currentPage >= maxPage) {
      return;
    }

    viewer.goToPage(currentPage + 1);
  });

  // In the image-only view the viewer column is only as tall as the viewer itself,
  // so the sticky element has no room to move and scrolls away with the page.
  // Extend the column to the bottom of the page to keep the viewer pinned while scrolling.
  const stickyColumn = document.querySelector("#img-resize.image-only-column");
  function updateStickyRange() {
    if (!stickyColumn) {
      return;
    }
    stickyColumn.style.minHeight = "";
    const docHeight = document.documentElement.scrollHeight;
    if (docHeight <= window.innerHeight) {
      return;
    }
    const colBottom = stickyColumn.getBoundingClientRect().bottom + window.scrollY;
    const extra = Math.round(docHeight - colBottom);
    if (extra > 0) {
      stickyColumn.style.minHeight = `${stickyColumn.offsetHeight + extra}px`;
    }
  }

  window.addEventListener(
    "resize",
    () => {
      resizeFacsContainer();
      viewer.forceResize();
      viewer.viewport.goHome();
      updateStickyRange();
    },
    { passive: true },
  );

  /* fullscreen: fill the screen, show OSD's default controls and re-fit the image */
  document.addEventListener("fullscreenchange", () => {
    facsContainer.classList.toggle("osd-fullscreen", !!document.fullscreenElement);
    resizeFacsContainer();
    viewer.forceResize();
    viewer.viewport.goHome();
    setTimeout(() => {
      resizeFacsContainer();
      viewer.forceResize();
      viewer.viewport.goHome();
    }, 250);
  });

  // Ensure late font/layout settling cannot leave the image seemingly cropped.
  const stabilizeAfterLayout = () => {
    resizeFacsContainer();
    viewer.forceResize();
    fitVerticallyCentered();
    updateStickyRange();
  };

  window.addEventListener("load", () => {
    setTimeout(stabilizeAfterLayout, 0);
    setTimeout(stabilizeAfterLayout, 350);
  });

  updateButtonState();
  updatePageSlider(currentPage);
  warmupNextIiifInfo(currentPage);
  updateStickyRange();
}