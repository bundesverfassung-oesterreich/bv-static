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
// needs to be done before calling the viewer construtor, 
// since it doesnt update size
resize_facsContainer();

var pb_elements = document.getElementsByClassName("pb");
var pb_elements_array = Array.from(pb_elements);
var tileSources = [];
var img = pb_elements[0].getAttribute("source");
var imageURL = {
  type: "image",
  url: img,
};
tileSources.push(imageURL);

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
  //homeFillsViewer: false,
  visibilityRatio: 1,
  sequenceMode: true,
  showNavigationControl: true,
  showNavigator: false,
  showSequenceControl: false,
  showZoomControl: true,
  //defaultZoomLevel: 1,
  zoomInButton:   "osd_zoom_in_button",
  zoomOutButton:  "osd_zoom_out_button",
  homeButton : "osd_zoom_reset_button",
  constrainDuringPan: true,
});

viewer.viewport.goHome = function () {
  fitVertically_align_left_bottom();
}

// function & event handler to set hight of image to max and pan the image to the left
// this is done via this handler & not in the load function due to laoding the initial tile via the
// tile source opt in constructor. 

function fitVertically_align_left_top() {
  let tiledImage = viewer.world.getItemAt(0);
  let bounds = viewer.viewport.getBounds(true);
  var newBounds = new OpenSeadragon.Rect(0, 0, 1, bounds.height / bounds.width);
  console.log(newBounds);
  console.log(tiledImage);
  viewer.viewport.fitBoundsWithConstraints(newBounds, true);
}

function fitVertically_align_left_bottom_bak() {
  let tiledImage = viewer.world.getItemAt(0);
  let bounds = viewer.viewport.getBounds(true);
  console.log(tiledImage);
  var newBounds = new OpenSeadragon.Rect(bounds.x, 0, 1, bounds.height / bounds.width);  
  console.log(bounds);
  console.log(newBounds);
  viewer.viewport.fitBounds(newBounds, true);
}

function fitVertically_align_left_bottom(){
  let initial_bounds = viewer.viewport.getBounds();
  console.log(initial_bounds);
  let ratio = initial_bounds.width / initial_bounds.height;
  console.log(viewer.world.getItemCount());
  let tiledImage = viewer.world.getItemAt(viewer.world.getItemCount()-1);
  console.log(viewer.world);
  console.log(tiledImage);
  console.log(ratio);
  if (ratio > tiledImage.contentAspectX) {
    var new_width = tiledImage.normHeight * ratio;
    var new_bounds = new OpenSeadragon.Rect(0, 0 , new_width, tiledImage.normHeight)
   
  } else {
    var new_height = 1 / ratio;
    let bounds_y = -(new_height - tiledImage.normHeight);
    var new_bounds = new OpenSeadragon.Rect(0, bounds_y, 1, new_height);
  }
  console.log(new_bounds);
  viewer.viewport.fitBounds(new_bounds, true);
  console.log(`is ${viewer.viewport.getBounds()}`);
}


function fitVertically_align_left_bottom_test() {
  let initial_bounds = viewer.viewport.getBounds();
  console.log(initial_bounds);
  let ratio = initial_bounds.width / initial_bounds.height;
  let tiledImage = viewer.world.getItemAt(0);
  console.log(tiledImage);
  console.log(ratio);
  if (ratio > tiledImage.contentAspectX) {
    var new_width = tiledImage.normHeight * ratio;
    let new_bounds = new OpenSeadragon.Rect(0, 0 , new_width, tiledImage.normHeight)
    viewer.viewport.fitVertically(true);
    let bounds = viewer.viewport.getBounds();
    console.log(`would have been ${new_bounds}`);
    bounds.x = 0;
    bounds.y = 0;
    viewer.viewport.fitBounds(new_bounds, true);
  } else {
    var new_height = 1 / ratio;
    let height_diff = new_height - tiledImage.normHeight;
    let bounds_y = -(height_diff);
    let new_bounds = new OpenSeadragon.Rect(0, bounds_y, 1, new_height);
    viewer.viewport.fitHorizontally(true);
    let bounds = viewer.viewport.getBounds();
    bounds.x = 0;
    let diff = bounds.height - tiledImage.normHeight;
    bounds.y = -(tiledImage.normHeight/2) + diff;
    console.log(`would have been ${new_bounds}`);
    let x = bounds.width/2;
    let y = (bounds.height/2) - diff;
    var point = new OpenSeadragon.Point(x,y);
    //var point = new OpenSeadragon.Point(x,y);
    //viewer.viewport.fitBounds(bounds, true);
    //viewer.viewport.panTo(point, true);
    viewer.viewport.fitBounds(new_bounds, true);
  }
  console.log(`is ${viewer.viewport.getBounds()}`);
}

viewer.addHandler("tile-loaded", (x) => {fitVertically_align_left_bottom(viewer)});

/*
##################################################################
index and previous index for click navigation in osd0viewer
locate index of anchor element
##################################################################
*/
var next_pb_index = 0;
var previous_pb_index = -1;
const a_elements = document.getElementsByClassName("anchor-pb");
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
  console.log("… scrolling …")
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
  viewer.addSimpleImage(
    {
      url: new_image,
      success: function (event) {
        function ready() {
          setTimeout(() => {
            viewer.world.removeItem(viewer.world.getItemAt(0));
          }, 200);
        }
        // test if item was loaded and trigger function to remove previous item
        if (event.item) {
          ready();
        } else {
          event.item.addOnceHandler("fully-loaded-change", ready());
        }
      },
    }
  );
}


function loadNewImage(new_item, dont_check=false) {
  if (new_item) {
    var new_image = new_item.getAttribute("source");
    var old_image = viewer.world.getItemAt(0);
    if (dont_check){
      add_image_to_viewer(new_image);
    } else if (old_image) {
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


/*
##################################################################
test to add whitespace at end of the page to make 
the scrolling mechanism work.
##################################################################
*/


/* since not all pages in the original document contain a lot of text,
it could happen that the image on the last page doesnt get loaded, cause 
its impossible to scroll far enough to trigger the load image stuff   */
// setting up eventlistener and Intersectionobserver

// create anchor as a point of reference for the end of the textblock
bell_anchor = document.createElement("a");
text_wrapper.appendChild(
  bell_anchor
);

// stuff to change / set the whitespace at bottom
var bottom_whitespace = 0;

function change_bottom_whitespace_of_textWrapper() {
  bottom_whitespace = ((window.innerHeight / 10) *8);
  text_wrapper.style.paddingBottom = `${bottom_whitespace}px`
};

function check_bottom_whitespace_of_textWrapper(check_bottom_whitespace) {
  if (check_bottom_whitespace === undefined) {
    check_bottom_whitespace = false;
  }
  if (check_bottom_whitespace === true){
    if (bottom_whitespace == 0) {
      change_bottom_whitespace_of_textWrapper();
    }
  } else {
      change_bottom_whitespace_of_textWrapper();
  }
}

// setting up eventlistener and Intersectionobserver
let io_options = {
  root: null,
  rootMargin: "0px",
  threshold: 1.0,
};

let observer = new IntersectionObserver(
  function () {check_bottom_whitespace_of_textWrapper(check_bottom_whitespace=true)},
  io_options
);

observer.observe(bell_anchor);


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
        fitVertically_align_left_bottom(viewer);
    };
    check_bottom_whitespace_of_textWrapper();
  }
);