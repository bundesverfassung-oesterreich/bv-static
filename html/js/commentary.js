(function () {
  var toggle = document.getElementById('commentary_toc_toggle');
  if (!toggle) return;

  var toc = document.querySelector('nav.commentary_toc');
  var button = document.querySelector('label.commentary_toc_toggle_button');

  document.addEventListener('click', function (event) {
    if (!toggle.checked) {
      return;
    }
    var target = event.target;

    // Click inside the TOC should not close it
    if (toc && toc.contains(target)) {
      return;
    }

    // Click on the toggle button should not close it here
    if (button && button.contains(target)) {
      return;
    }

    // Direct click on the checkbox should behave normally
    if (target === toggle) {
      return;
    }

    // Any other click closes the TOC
    toggle.checked = false;
  });
})();
