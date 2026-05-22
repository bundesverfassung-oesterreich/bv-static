const facsContainer = document.getElementById("container_facs_1");
const imageRights = document.getElementsByClassName("image_rights")[0];
const imageSourceNodes = Array.from(document.querySelectorAll(".image-source"));

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

  const tileSources = imageSourceNodes.map((node) => ({
    type: "image",
    url: node.dataset.imageUrl,
  }));

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
    constrainDuringPan: true,
  });

  function fitVerticallyCentered() {
    const initialBounds = viewer.viewport.getBounds();
    const ratio = initialBounds.width / initialBounds.height;
    const tiledImage = viewer.world.getItemAt(viewer.world.getItemCount() - 1);

    if (!tiledImage) {
      return;
    }

    let newBounds;
    if (ratio > tiledImage.contentAspectX) {
      const newWidth = tiledImage.normHeight * ratio;
      const centeredX = (1 - newWidth) / 2;
      newBounds = new OpenSeadragon.Rect(
        centeredX,
        0,
        newWidth,
        tiledImage.normHeight,
      );
    } else {
      const newHeight = 1 / ratio;
      const centeredY = (tiledImage.normHeight - newHeight) / 2;
      newBounds = new OpenSeadragon.Rect(0, centeredY, 1, newHeight);
    }

    viewer.viewport.fitBounds(newBounds, true);
  }

  viewer.viewport.goHome = function () {
    fitVerticallyCentered();
  };

  viewer.addHandler("open", fitVerticallyCentered);
  viewer.addHandler("tile-loaded", fitVerticallyCentered);
  viewer.addHandler("page", fitVerticallyCentered);

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
  });

  prev.addEventListener("click", () => {
    viewer.goToPage(Math.max(currentPage - 1, 0));
  });

  next.addEventListener("click", () => {
    viewer.goToPage(Math.min(currentPage + 1, maxPage));
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
}