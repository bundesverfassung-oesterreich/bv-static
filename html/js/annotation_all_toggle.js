/* The "Alles" switch lives in the settings offcanvas (#ef, built by de-editor).
   The image controls carry a button with the same function and state, so this
   keeps both in sync. Loaded after run.js, which makes de-editor render #ef. */
const all_annotations_slider = document.getElementById('ef');
const all_annotations_button = document.getElementById('osd_annotation_toggle');

if (all_annotations_slider && all_annotations_button) {
  const sync_all_annotations_button = () => {
    all_annotations_button.setAttribute('aria-pressed', String(all_annotations_slider.checked));
  };

  all_annotations_button.addEventListener('click', () => {
    // let de-editor run its own handler, so features, citation url and the
    // settings switch all end up in exactly the state a click there produces
    all_annotations_slider.click();
    sync_all_annotations_button();
  });

  // de-editor flips the slider by setting .checked and the "active" class from
  // several places (initial defaults, its own click handler) without an event
  new MutationObserver(sync_all_annotations_button).observe(all_annotations_slider, {
    attributes: true,
    attributeFilter: ['class'],
  });

  // the defaults are applied in de-editor's window.onload handler
  window.addEventListener('load', sync_all_annotations_button);
  sync_all_annotations_button();
}
