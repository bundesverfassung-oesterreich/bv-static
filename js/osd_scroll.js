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
  let image_rights_height = image_rights.getBoundingClientRect().height;
  let new_container_height =
    window.innerHeight -
    (window.innerHeight / 10 + //this is necessary, cause container has fixed top val of 10%
    image_rights_height);
  return Math.round(new_container_height);
};

function resize_facsContainer() {
    let new_container_height = calculate_facsContainer_height();
    if (new_container_height != container_facs_1.clientHeight) {
      container_facs_1.style.height = `${String(new_container_height)}px`;
    };
};

resize_facsContainer()
const throttle = function (throttled_func, delay_ms) {
  let time = Date.now();
  if (delay_ms === undefined) {
    delay_ms = 20;
  } 
  return () => {
    if((time + delay_ms - Date.now()) <= 0) {
      throttled_func();
      time = Date.now();
    };
  };
};

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
var viewer = OpenSeadragon({
  id: "container_facs_1",
  prefixUrl:
    "https://cdnjs.cloudflare.com/ajax/libs/openseadragon/4.1.0/images/",
  sequenceMode: true,
  //showNavigator: true,
  tileSources: tileSources,
});
/*
##################################################################
remove container holding the images url
##################################################################
*/
// setTimeout(function() {
//     document.getElementById("container_facs_2").remove();
// }, 500);

/*
##################################################################
index and previous index for click navigation in osd viewer
locate index of anchor element
##################################################################
*/
var next_pb_index = 0;
var previous_pb_index = -1;
const a_elements = document.getElementsByClassName("anchor-pb");
const max_index = (a_elements.length - 1);
const prev = document.querySelector("div[title='Previous page']");
const next = document.querySelector("div[title='Next page']");
/*
##################################################################
triggers on scroll and switches osd viewer image base on 
viewport position of next and previous element with class pb
pb = pagebreaks
##################################################################
*/
function load_top_viewport_image(check=true) {
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
      
      console.log(`Didnt check for visibility. Scrolling to ${current_pb_index}`);
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
  viewer.addSimpleImage({
    url: new_image,
    success: function (event) {
      function ready() {
        setTimeout(() => {
          viewer.world.removeItem(viewer.world.getItemAt(0));
        }, 200);
      }
      // test if item was loaded and trigger function to remove previous item
      if (event.item) {
        // .getFullyLoaded()
        ready();
      } else {
        event.item.addOnceHandler("fully-loaded-change", ready());
      }
    },
  });
}

function loadNewImage(new_item, dont_check=false) {
  if (new_item) {
    // source attribute hold image item id without url
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
  // Checking part. Here the code checks if el is close to top of viewport.
  // console.log("Top");
  // console.log(bounding.top);
  // console.log("Bottom");
  // console.log(bounding.bottom);
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
  // console.log("Top");
  // console.log(bounding.top);
  // console.log("Bottom");
  // console.log(bounding.bottom);
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
addEventListener("resize", check_bottom_whitespace_of_textWrapper);

window.addEventListener("load", function() {
  if (window.location.href.includes("#")) {
    load_top_viewport_image(false);
  }
});