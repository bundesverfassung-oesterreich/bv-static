const facsContainer = document.getElementById("container_facs_1");
const imageRights = document.getElementsByClassName("image_rights")[0];
const imageSourceNodes = Array.from(document.querySelectorAll(".image-source"));

const IIIF_IMAGE_SUFFIX = /\/full\/(?:full|max)\/0\/default\.(?:jpg|jpeg|png)(?:\?.*)?$/i;

function toIiifInfoUrl(imageUrl) {
  if (!imageUrl) {
    return "";
  }

  if (imageUrl.endsWith("/info.json")) {
    return imageUrl;
  }

  if (IIIF_IMAGE_SUFFIX.test(imageUrl)) {
    return imageUrl.replace(IIIF_IMAGE_SUFFIX, "/info.json");
  }

  return imageUrl;
}

if (facsContainer && imageRights && imageSourceNodes.length > 0) {
  function calculateFacsContainerHeight() {
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
    showSequenceControl: false,
    showZoomControl: true,
    zoomInButton: "osd_zoom_in_button",
    zoomOutButton: "osd_zoom_out_button",
    homeButton: "osd_zoom_reset_button",
    preload: true,
    constrainDuringPan: true,
    imageLoaderLimit: 3,
    timeout: 60000,
    tileRetryMax: 2,
    tileRetryDelay: 1500,
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

  viewer.addHandler("open", () => {
    fitVerticallyCentered();

    // Refit once after the image is fully loaded to avoid edge clipping.
    const tiledImage = viewer.world.getItemAt(viewer.world.getItemCount() - 1);
    if (tiledImage && typeof tiledImage.addOnceHandler === "function") {
      tiledImage.addOnceHandler("fully-loaded-change", fitVerticallyCentered);
    }
  });

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

  function updateButtonState() {
    prev.style.opacity = currentPage === 0 ? 0.6 : 1;
    next.style.opacity = currentPage === maxPage ? 0.6 : 1;
  }

  viewer.addHandler("page", (event) => {
    currentPage = event.page;
    updateButtonState();
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

  window.addEventListener(
    "resize",
    () => {
      resizeFacsContainer();
      viewer.viewport.goHome();
    },
    { passive: true },
  );

  updateButtonState();
  warmupNextIiifInfo(currentPage);
}