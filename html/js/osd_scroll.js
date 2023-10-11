const container_facs_1 = document.getElementById("container_facs_1");
const text_wrapper = document.getElementById("text-resize");
container_facs_1.style.height = `${String(screen.height / 2)}px`;
//container_facs_1.style.height = `${String(window.innerHeight - container_facs_1.offset.top)}px`;
/*var wrapper_column = document.getElementsByClassName("facsimiles")[0];
var text_container = document.getElementById("section");
const image_size_relations =
  container_facs_1.getBoundingClientRect().width /
  Number(container_facs_1.style.height.replace("px", ""));
// set osd wrapper container width
var container = document.getElementById("viewer");
if (text_container !== null) {
  var width = text_container.clientWidth;
} else {
  var width = 0;
}
// check if facsimiles are displayed
container.style.width = "auto";
if (!wrapper_column.classList.contains("fade")) {
  // if true get width from sibling container - offset
  container.style.width = `${String(width - 25)}px`;
} else {
  // if false get width from sibling container / 2
  container.style.width = `${String(width.clientWidth / 2)}px`;
}*/


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

var element = document.getElementsByClassName("pb");
var tileSources = [];
var img = element[0].getAttribute("source");
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
  showNavigator: true,
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
var current_pb_index = 0;
var previous_pb_index = -1;

/*
##################################################################
triggers on scroll and switches osd viewer image base on 
viewport position of next and previous element with class pb
pb = pagebreaks
##################################################################
*/
window.addEventListener(
  "scroll", 
  function (event) {
    // elements in view
    var elements_in_viewport = [];
    for (let el of element) {
      if (isInViewportAll(el)) {
        elements_in_viewport.push(el);
      }
    }
    if (elements_in_viewport.length != 0) {
      // first element in view
      var first_element_in_viewport = elements_in_viewport[0];
      // get current_pb_index of element
      var first_element_in_viewport_index = Array.from(element).findIndex((el) => el === first_element_in_viewport);
      current_pb_index = first_element_in_viewport_index + 1;
      previous_pb_index = first_element_in_viewport_index - 1;
      // test if element is in viewport position to load correct image
      if (isInViewport(element[first_element_in_viewport_index])) {
        loadNewImage(element[first_element_in_viewport_index]);
      }
    }
  },
  {passive: true}
);

/*
##################################################################
function to trigger image load and remove events
##################################################################
*/
function loadNewImage(new_item) {
  if (new_item) {
    // source attribute hold image item id without url
    var new_image = new_item.getAttribute("source");
    var old_image = viewer.world.getItemAt(0);
    if (old_image) {
      // get url from current/old image and replace the image id with
      // new id of image to be loaded
      // access osd viewer and add simple image and remove current image
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
  }
}

/*
##################################################################
accesses osd viewer prev and next button to switch image and
scrolls to next or prev span element with class pb (pagebreak)
##################################################################
*/
var element_a = document.getElementsByClassName("anchor-pb");
var prev = document.querySelector("div[title='Previous page']");
var next = document.querySelector("div[title='Next page']");
prev.style.opacity = 1;
next.style.opacity = 1;
prev.addEventListener("click", () => {
  if (current_pb_index == 0) {
    element_a[current_pb_index].scrollIntoView();
  } else {
    element_a[previous_pb_index].scrollIntoView();
  }
});
next.addEventListener("click", () => {
  throttle(
    element_a[current_pb_index].scrollIntoView(),
    delay_ms=10
  )
});

/*
##################################################################
function to check if element is close to top of window viewport
##################################################################
*/
function isInViewport(element) {
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
function isInViewportAll(element) {
  // Get the bounding client rectangle position in the viewport
  var bounding = element.getBoundingClientRect();
  // Checking part. Here the code checks if el is close to top of viewport.
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
eventlisteners to max hight of the container
##################################################################
*/
/*
const image_rights = document.getElementsByClassName("image_rights")[0];
function calculate_facsContainer_height(facsContainer) {
  let image_rights_height = image_rights.getBoundingClientRect().height;
  let new_container_height =
    window.innerHeight -
    facsContainer.getBoundingClientRect().top -
    image_rights_height;
  return Math.round(new_container_height);
};

function resize_facsContainer() {
    let new_container_height = calculate_facsContainer_height(container_facs_1);
    if (new_container_height != container_facs_1.clientHeight) {
      container_facs_1.style.height = `${String(new_container_height)}px`;
    };
};*/
/*
// create event-listeners
var osd_container_resize_events = ["scroll", "resize", "load"];
for (trigger_event_type of osd_container_resize_events) {
  window.addEventListener(
    trigger_event_type,
    //resize_facsContainer
    throttle(
      resize_facsContainer
    )
  );
};*/


// test
bell_anchor = document.createElement("a");

text_wrapper.appendChild(
  bell_anchor
);

var bottom_whitespace = 0;
function check_bottom_whitespace_of_textWrapper(check_bottom_whitespace) {
  if (check_bottom_whitespace === undefined) {
    check_bottom_whitespace = false;
    console.log("bottom whitespace was undefined");
  }
  if (check_bottom_whitespace === true){
    console.log("checking bottom whitespace");
    if (bottom_whitespace == 0) {
      console.log("bottom whitespace was 0");
      change_bottom_whitespace_of_textWrapper();
    }
  } else {
      console.log("not even checking bottom whitespace");
      change_bottom_whitespace_of_textWrapper();
  }
}

function change_bottom_whitespace_of_textWrapper() {
  console.log("changing the bottom whitespace");
  bottom_whitespace = ((window.innerHeight / 10) *8);
  console.log(bottom_whitespace);
  text_wrapper.style.paddingBottom = `${bottom_whitespace}px`
};

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