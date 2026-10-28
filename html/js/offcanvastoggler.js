function handle_the_handler(off_canvas_id) {
    let offcanvas_container_div = document.getElementById(off_canvas_id);
    if (offcanvas_container_div) {
      const hideCanvas = (event) => {
        let openedCanvas = bootstrap.Offcanvas.getInstance(offcanvas_container_div);
        openedCanvas.hide();
        event.target.removeEventListener('mouseleave', hideCanvas);
      }
      const listenToMouseLeave = (event) => {
        event.target.addEventListener('mouseleave', hideCanvas);
      }
      offcanvas_container_div.addEventListener('shown.bs.offcanvas', listenToMouseLeave);
    }
  }



/*window.addEventListener("load", function() {
  let disclaimer = document.getElementById("text_quality_disclaimer");
  let openedCanvas = bootstrap.Offcanvas.getInstance(disclaimer);
  openedCanvas.hide();
});*/

  //function call
  handle_the_handler('offcanvasNavigation');
  handle_the_handler('text_quality_disclaimer');
  // rather annoying to use it there

/* The offcanvas panels are non-modal (data-bs-scroll="true", data-bs-backdrop="false"),
   so bootstrap neither moves focus into them nor keeps aria-expanded in sync on the
   triggers. Both are needed for keyboard and screen reader use: the panel content has to
   be reachable with Tab, and the panel's own Escape handler only fires when it has focus. */
const offcanvas_openers = new WeakMap();

document.querySelectorAll('.offcanvas').forEach((panel) => {
  if (!panel.id) {
    return;
  }
  const triggers = () => document.querySelectorAll(`[data-bs-toggle="offcanvas"][aria-controls="${panel.id}"]`);

  panel.addEventListener('show.bs.offcanvas', (event) => {
    const opener = event.relatedTarget
      || (document.activeElement instanceof HTMLElement ? document.activeElement : null);
    if (opener instanceof HTMLElement && opener !== document.body && !panel.contains(opener)) {
      offcanvas_openers.set(panel, opener);
    }
    triggers().forEach((trigger) => trigger.setAttribute('aria-expanded', 'true'));
  });

  panel.addEventListener('shown.bs.offcanvas', () => {
    const close_button = panel.querySelector('.offcanvas-header .btn-close');
    const focus_target = close_button || panel;
    if (!close_button && !focus_target.hasAttribute('tabindex')) {
      focus_target.setAttribute('tabindex', '-1');
    }
    focus_target.focus();
  });

  panel.addEventListener('hide.bs.offcanvas', () => {
    triggers().forEach((trigger) => trigger.setAttribute('aria-expanded', 'false'));
  });

  /* Bootstrap only returns focus to a trigger it handled itself (a click on the toggler).
     Escape, the mouse-leave auto-close above and closing via the close button bypass that,
     so focus would be dropped on the body. Put it back on the element that opened the panel. */
  panel.addEventListener('hidden.bs.offcanvas', () => {
    const opener = offcanvas_openers.get(panel);
    offcanvas_openers.delete(panel);
    if (!opener || !opener.isConnected) {
      return;
    }
    // only take focus back if it was left on the panel that just disappeared
    const active_element = document.activeElement;
    if (active_element === panel || panel.contains(active_element) || active_element === document.body) {
      opener.focus();
    }
  });
});

/* The annotation toggles in the settings panel are produced by the bundled de-editor.min.js
   as a transparent <input type="checkbox"> inside <label class="switch">, plus a sibling
   <label> holding the visible text. That label is not associated with the input, so the text
   is not clickable, and a checkbox only reacts to Space -- not to Enter. Both are repaired
   here from the outside, so the vendor bundle stays untouched. The focus ring itself is pure
   CSS (see #edition_display_options in style.css). */
function associate_annotation_toggle_labels() {
  document.querySelectorAll('#edition_display_options annotation-slider').forEach((toggle) => {
    const input = toggle.querySelector('input[type="checkbox"]');
    const text_label = toggle.querySelector(':scope > label:not(.switch)');
    if (input && input.id && text_label && !text_label.hasAttribute('for')) {
      text_label.setAttribute('for', input.id);
    }
  });
}

// delegated, so it keeps working when a custom element re-renders itself
document.addEventListener('keydown', (event) => {
  if (event.key !== 'Enter' || event.altKey || event.ctrlKey || event.metaKey) {
    return;
  }
  const input = event.target;
  if (!(input instanceof HTMLInputElement) || input.type !== 'checkbox') {
    return;
  }
  if (!input.closest('#edition_display_options')) {
    return;
  }
  event.preventDefault();
  input.click();
});

window.addEventListener('load', associate_annotation_toggle_labels);
document.getElementById('offcanvasOptions')?.addEventListener('shown.bs.offcanvas', associate_annotation_toggle_labels);
