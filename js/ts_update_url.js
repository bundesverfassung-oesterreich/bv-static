var tsInput = document.querySelector("input[type='search']");
tsInput.addEventListener("input", updateHeaderUrl);
const regexp = new RegExp("(^.\/bv_doc_id__\\d\.html)(#navigation_[a-z]*_\\d+)(.*)")

function listenToPagination() {
  setTimeout(() => {
    var tsPagination = document.querySelectorAll(".ais-Pagination-link");
    [].forEach.call(tsPagination, function (opt) {
      opt.removeEventListener("click", updateHeaderUrl);
      opt.addEventListener("click", updateHeaderUrl);
    });
  }, 100);
}
setTimeout(() => {
  listenToPagination();
}, 100);

function updateHeaderUrl() {
  setTimeout(() => {
    var elementsWithUrl = document.querySelectorAll(".ais-Hits-item h5 a");
    var tsInputVal = tsInput.value;
    elementsWithUrl.forEach((el) => {
      var hrefVal = el.getAttribute("href");
      var match = hrefVal.match(regexp)
      if (match != null) {
          if (match[3] != "") {
            var newHrefVal = `${match[1]}?mark=${tsInputVal}&${match[3]}${match[2]}`;
          }
          else {
            var newHrefVal = `${match[1]}?mark=${tsInputVal}${match[2]}`;
          }
          el.setAttribute("href", newHrefVal);
      }
    });

    // listenToCheckbox();
    listenToPagination();
  }, 500);
}
