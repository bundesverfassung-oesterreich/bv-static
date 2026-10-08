const container_facs_1 = document.getElementById("container_facs_1");
const text_wrapper = document.getElementById("text-resize");
container_facs_1.style.height = `${String(screen.height / 2)}px`;
/*
##################################################################
get all image urls stored in span el class tei-xml-images
creates an array for osd viewer with static images
##################################################################
*/
const navbar_wrapper = document.getElementById("wrapper-navbar");
const image_rights = document.getElementsByClassName("image_rights")[0];
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


function calculate_facsContainer_height() {
  // when the container itself is the fullscreen element, fill the whole screen
  // (page-level fullscreen must keep the normal height formula instead)
  if (document.fullscreenElement === container_facs_1) {
    return Math.round(window.innerHeight);
  }
  // calcutlates hight of osd container based on heigt of screen - (height of navbar + img rights&buttons)
  let image_rights_height = image_rights.getBoundingClientRect().height;
  let new_container_height =
    window.innerHeight -
    (window.innerHeight / 10 + //this is necessary, cause container has fixed top val of 10%
    image_rights_height);
  return Math.round(new_container_height);
};

// initially resizing the facs container to max
// needs to be done before calling the viewer constructor, 
// since it doesnt update size
resize_facsContainer();

var pb_elements = document.getElementsByClassName("pb");
var pb_elements_array = Array.from(pb_elements);
var tileSources = [];
var img = pb_elements[0].getAttribute("source");
var initialTileSource = toIiifInfoUrl(img);
var currentViewerSource = initialTileSource;
tileSources.push(initialTileSource);

/*
##################################################################
initialize osd
##################################################################
*/
const viewer = new OpenSeadragon.Viewer({
  id: "container_facs_1",
  prefixUrl:
    "https://cdnjs.cloudflare.com/ajax/libs/openseadragon/4.1.0/images/",
  tileSources: tileSources,
  visibilityRatio: 1,
  sequenceMode: true,
  showNavigationControl: true,
  showNavigator: false,
  showSequenceControl: true,
  showZoomControl: true,
  constrainDuringPan: true,
  preserveViewport: true,
});

viewer.viewport.goHome = function () {
  fitVertically_align_left_bottom();
}

// OSD's default controls carry no class names - tag their container so CSS can
// hide it in the normal layout and only reveal it in fullscreen
container_facs_1
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

/* OSD greys out buttons it has disabled (prev/next here when they are unusable) -
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

function fitVertically_align_left_bottom(){
  const tiledImage = viewer.world.getItemAt(viewer.world.getItemCount() - 1);
  if (!tiledImage) {
    return;
  }

  // Fit to actual image bounds to prevent late clipping on tile load.
  viewer.viewport.fitBounds(tiledImage.getBounds(), true);
  viewer.viewport.applyConstraints(true);
}

/* The currently displayed view, stored as fractions of the displayed image
   (so it can be mapped onto the next image on load). */
var saved_image_view = null;

// The current view as fractions of the displayed image (null while no image).
function read_image_view() {
  const tiledImage = viewer.world.getItemAt(viewer.world.getItemCount() - 1);
  if (!tiledImage) {
    return null;
  }
  const imageBounds = tiledImage.getBounds();
  const viewBounds = viewer.viewport.getBounds();
  return {
    x: (viewBounds.x - imageBounds.x) / imageBounds.width,
    y: (viewBounds.y - imageBounds.y) / imageBounds.height,
    width: viewBounds.width / imageBounds.width,
    height: viewBounds.height / imageBounds.height,
  };
}

// Remember which relative section of the currently shown image is displayed.
function capture_image_view() {
  const rel = read_image_view();
  if (rel) {
    saved_image_view = rel;
  }
}

// Show the given relative section (and zoom) of the displayed image; a plain
// fit is used when no section is given (initial load).
function apply_image_view(rel) {
  const tiledImage = viewer.world.getItemAt(viewer.world.getItemCount() - 1);
  if (!tiledImage) {
    return;
  }
  if (!rel) {
    fitVertically_align_left_bottom();
    return;
  }
  const imageBounds = tiledImage.getBounds();
  const targetBounds = new OpenSeadragon.Rect(
    imageBounds.x + rel.x * imageBounds.width,
    imageBounds.y + rel.y * imageBounds.height,
    rel.width * imageBounds.width,
    rel.height * imageBounds.height
  );
  viewer.viewport.fitBounds(targetBounds, true);
  viewer.viewport.applyConstraints(true);
}

function apply_captured_image_view() {
  apply_image_view(saved_image_view);
}

// True while the whole image is visible - i.e. the view is still at its
// fitted/default state (used to decide whether a container resize may refit).
function is_whole_image_visible() {
  const tiledImage = viewer.world.getItemAt(viewer.world.getItemCount() - 1);
  if (!tiledImage) {
    return true;
  }
  const imageBounds = tiledImage.getBounds();
  const viewBounds = viewer.viewport.getBounds();
  const marginX = imageBounds.width * 0.01;
  const marginY = imageBounds.height * 0.01;
  return (
    viewBounds.x <= imageBounds.x + marginX &&
    viewBounds.y <= imageBounds.y + marginY &&
    viewBounds.x + viewBounds.width >= imageBounds.x + imageBounds.width - marginX &&
    viewBounds.y + viewBounds.height >= imageBounds.y + imageBounds.height - marginY
  );
}

/* adapt the view to a container size change: refit at the default view, otherwise
   keep the current section and zoom (only the visible extent changes) */
function adapt_view_to_container_resize() {
  const wasFitted = is_whole_image_visible();
  capture_image_view();
  if (!resize_facsContainer()) {
    return;
  }
  viewer.forceResize();
  const apply_view = () => {
    if (wasFitted) {
      fitVertically_align_left_bottom();
    } else {
      apply_captured_image_view();
    }
  };
  apply_view();
  // OSD rescales the viewport on its next frame - re-apply once afterwards for an exact result.
  setTimeout(apply_view, 250);
}

viewer.addHandler("open", () => {
  apply_captured_image_view();

  const tiledImage = viewer.world.getItemAt(viewer.world.getItemCount() - 1);
  if (tiledImage && typeof tiledImage.addOnceHandler === "function") {
    tiledImage.addOnceHandler("fully-loaded-change", apply_captured_image_view);
  }
});

/*
##################################################################
index and previous index for click navigation in osd0viewer
locate index of anchor element
##################################################################
*/
var next_pb_index = 0;
var previous_pb_index = -1;
const a_elements = document.getElementsByClassName("pb");
//const a_elements = document.getElementsByClassName("anchor-pb");
const max_index = (a_elements.length - 1);
const prev = document.getElementById("osd_prev_button");
const next = document.getElementById("osd_next_button");

/*
##################################################################
triggers on scroll and switches osd viewer image base on 
viewport position of next and previous element with class pb
pb = pagebreaks
##################################################################
*/

function load_top_viewport_image(check=false) {
  // elements in view
  let first_pb_element_in_viewport = undefined;
  for (let pb_element of pb_elements) {
    if (isInViewport(pb_element)) {
      first_pb_element_in_viewport = pb_element;
      break;
    }
  }
  if (first_pb_element_in_viewport != undefined) {
    // get next_pb_index of element
    let current_pb_index = pb_elements_array.findIndex((el) => el === first_pb_element_in_viewport);
    next_pb_index = current_pb_index + 1;
    previous_pb_index = current_pb_index - 1;
    // test if element is in viewport position to load correct image
    let current_pb_element = pb_elements[current_pb_index];
    if (check) {
      if (isInTopViewport(current_pb_element)) {
        loadNewImage(current_pb_element);
      };
    } else {
      loadNewImage(current_pb_element, true);
    }
  }
}

// Function to handle initial scroll position when the page loads
function handleInitialScrollPosition() {
  // Check if the page loads with an anchor element's ID
  if (window.location.hash) {
    // Extract the ID from the URL hash
    const id = window.location.hash.substring(1);
    // Scroll to the element with the corresponding ID
    const targetElement = document.getElementById(id);
    if (targetElement) {
      targetElement.scrollIntoView();
      // After scrolling, trigger the functionality for handling the scroll position
      load_top_viewport_image();
    }
  }
}

// Call the function to handle initial scroll position when the page loads
handleInitialScrollPosition();

document.addEventListener(
  "scroll",
  load_top_viewport_image,
  {passive: true}
);


/*
##################################################################
function to trigger image load and remove events
##################################################################
*/

function add_image_to_viewer(new_image) {
  const nextSource = toIiifInfoUrl(new_image);
  if (!nextSource || nextSource === currentViewerSource) {
    return;
  }

  currentViewerSource = nextSource;
  capture_image_view();
  viewer.open(nextSource);
}


function loadNewImage(new_item, dont_check=false) {
  if (new_item) {
    var new_image = new_item.getAttribute("source");
    if (dont_check){
      add_image_to_viewer(new_image);
    } else if (viewer.world.getItemAt(0)) {
      add_image_to_viewer(new_image);
    }
  }
}

/*
##################################################################
accesses osd viewer prev and next button to switch image and
scrolls to next or prev span element with class pb (pagebreak)
##################################################################
*/

prev.style.opacity = 1;
next.style.opacity = 1;

function scroll_prev() {
  if (previous_pb_index == -1) {
    a_elements[0].scrollIntoView();
  } else {
    a_elements[previous_pb_index].scrollIntoView();
  };
};

function scroll_next() {
  if (next_pb_index > max_index) {
    a_elements[max_index].scrollIntoView();
  } else {
    a_elements[next_pb_index].scrollIntoView();
  };
};

prev.addEventListener("click", () => {
  scroll_prev();
});
next.addEventListener("click", () => {
  scroll_next()
});

/*
##################################################################
function to check if element is close to top of window viewport
##################################################################
*/
function isInTopViewport(element) {
  // Get the bounding client rectangle position in the viewport
  var bounding = element.getBoundingClientRect();
  if (
    bounding.top <= 180 &&
    bounding.bottom <= 210 &&
    bounding.top >= 0 &&
    bounding.bottom >= 0
  ) {
    return true;
  } else {
    return false;
  }
}

/*
##################################################################
function to check if element is anywhere in window viewport
##################################################################
*/
function isInViewport(element) {
  // Get the bounding client rectangle position in the viewport
  var bounding = element.getBoundingClientRect();
  if (
    bounding.top >= 0 &&
    bounding.left >= 0 &&
    bounding.bottom <=
      (window.innerHeight || document.documentElement.clientHeight) &&
    bounding.right <=
      (window.innerWidth || document.documentElement.clientWidth)
  ) {
    return true;
  } else {
    return false;
  }
}

/* change size of facs container */
function resize_facsContainer() {
  let new_container_height = calculate_facsContainer_height();
  if (new_container_height != container_facs_1.clientHeight) {
    container_facs_1.style.height = `${String(new_container_height)}px`;
    return true;
  };
  return false;
};


addEventListener("resize", function () {
    // refit at the default view; while zoomed keep the section and zoom
    adapt_view_to_container_resize();
  }
);

/* fullscreen: fill the screen, show OSD's default controls and re-fit the image */
function fit_viewer_to_fullscreen() {
  resize_facsContainer();
  viewer.forceResize();
  fitVertically_align_left_bottom();
}

let last_fullscreen_was_page = false;
document.addEventListener("fullscreenchange", function () {
  const fullscreenElement_now = document.fullscreenElement;
  const viewer_is_fullscreen = fullscreenElement_now === container_facs_1;
  const page_is_fullscreen = !!fullscreenElement_now && !viewer_is_fullscreen;
  const page_transition = page_is_fullscreen || (last_fullscreen_was_page && !fullscreenElement_now);
  last_fullscreen_was_page = page_is_fullscreen;

  container_facs_1.classList.toggle("osd-fullscreen", viewer_is_fullscreen);
  update_page_fullscreen_button();

  if (page_transition) {
    /* whole page fullscreen: keep the current section and zoom, only adapt the size */
    adapt_view_to_container_resize();
    return;
  }

  fit_viewer_to_fullscreen();
  setTimeout(fit_viewer_to_fullscreen, 250);
});

/* fullscreen button for the whole page, in the settings offcanvas */
const page_fullscreen_button = document.getElementById("page_fullscreen_button");

function update_page_fullscreen_button() {
  const label = document.getElementById("page_fullscreen_button_label");
  if (label) {
    label.textContent =
      document.fullscreenElement === document.documentElement
        ? "Vollbild beenden"
        : "Ganze Seite im Vollbild";
  }
}

if (page_fullscreen_button) {
  page_fullscreen_button.addEventListener("click", () => {
    if (document.fullscreenElement === document.documentElement) {
      document.exitFullscreen();
      return;
    }
    document.documentElement
      .requestFullscreen()
      .then(() => {
        // close the settings panel so the whole page is visible at once
        const options_panel = document.getElementById("offcanvasOptions");
        if (options_panel && window.bootstrap && bootstrap.Offcanvas) {
          bootstrap.Offcanvas.getOrCreateInstance(options_panel).hide();
        }
      })
      .catch(() => {});
  });
}

/* keep the view stable when the controls & image rights area is collapsed/expanded:
   at the default view a toggle refits; while zoomed, collapsing keeps zoom and
   section (gaining space) and the following expand restores the exact previous
   view (as long as the view was not changed in between) */
const image_rights_collapsible = document.getElementById("image_rights_collapsible");
if (image_rights_collapsible) {
  let view_before_collapse = null; // captured while zoomed, used by the next expand
  let collapsed_view_state = null; // measured after the collapse settled

  const read_view_state = () => {
    const rel = read_image_view();
    return rel ? { rel: rel, zoom: viewer.viewport.getZoom() } : null;
  };

  const views_match = (a, b) => {
    if (!a || !b) {
      return false;
    }
    return (
      Math.abs(a.zoom - b.zoom) / b.zoom < 0.01 &&
      Math.abs(a.rel.x - b.rel.x) < 0.02 &&
      Math.abs(a.rel.y - b.rel.y) < 0.02 &&
      Math.abs(a.rel.width - b.rel.width) < 0.02 &&
      Math.abs(a.rel.height - b.rel.height) < 0.02
    );
  };

  // Resize the container, re-apply the view immediately and once more after OSD
  // has processed the resize on its next frame (it rescales the viewport then).
  const resize_and_apply = (apply) => {
    if (!resize_facsContainer()) {
      return false;
    }
    viewer.forceResize();
    apply();
    setTimeout(apply, 250);
    return true;
  };

  const on_controls_collapsed = function () {
    view_before_collapse = null;
    collapsed_view_state = null;
    if (is_whole_image_visible()) {
      resize_and_apply(() => fitVertically_align_left_bottom());
      return;
    }
    view_before_collapse = read_view_state();
    const keep_section = view_before_collapse.rel;
    if (resize_and_apply(() => apply_image_view(keep_section))) {
      setTimeout(() => {
        collapsed_view_state = read_view_state();
      }, 400);
    }
  };

  const on_controls_expanded = function () {
    const stored_view = view_before_collapse;
    const expected_state = collapsed_view_state;
    view_before_collapse = null;
    collapsed_view_state = null;
    if (stored_view && expected_state && views_match(read_view_state(), expected_state)) {
      resize_and_apply(() => apply_image_view(stored_view.rel));
      return;
    }
    if (is_whole_image_visible()) {
      resize_and_apply(() => fitVertically_align_left_bottom());
    } else {
      capture_image_view();
      resize_and_apply(apply_captured_image_view);
    }
  };

  image_rights_collapsible.addEventListener("hidden.bs.collapse", on_controls_collapsed);
  image_rights_collapsible.addEventListener("shown.bs.collapse", on_controls_expanded);
}