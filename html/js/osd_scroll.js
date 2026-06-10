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
  showSequenceControl: false,
  showZoomControl: true,
  zoomInButton: "osd_zoom_in_button",
  zoomOutButton: "osd_zoom_out_button",
  homeButton : "osd_zoom_reset_button",
  constrainDuringPan: true,
});

viewer.viewport.goHome = function () {
  fitVertically_align_left_bottom();
}

function fitVertically_align_left_bottom(){
  const tiledImage = viewer.world.getItemAt(viewer.world.getItemCount() - 1);
  if (!tiledImage) {
    return;
  }

  // Fit to actual image bounds to prevent late clipping on tile load.
  viewer.viewport.fitBounds(tiledImage.getBounds(), true);
  viewer.viewport.applyConstraints(true);
}

viewer.addHandler("open", () => {
  fitVertically_align_left_bottom();

  const tiledImage = viewer.world.getItemAt(viewer.world.getItemCount() - 1);
  if (tiledImage && typeof tiledImage.addOnceHandler === "function") {
    tiledImage.addOnceHandler("fully-loaded-change", fitVertically_align_left_bottom);
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


addEventListener("resize", function (event) {
    let resized = resize_facsContainer();
    if (resized) {
        viewer.forceResize();
        fitVertically_align_left_bottom();
    };
  }
);