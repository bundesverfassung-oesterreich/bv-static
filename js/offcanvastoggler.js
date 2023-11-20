function handle_the_handler(off_canvas_id) {
    let offcanvas_container_div = document.getElementById(off_canvas_id);
    const hideCanvas = () => {
      let openedCanvas = bootstrap.Offcanvas.getInstance(offcanvas_container_div);
      openedCanvas.hide();
      target.removeEventListener('mouseleave', hideCanvas);
    }
    const listenToMouseLeave = (event) => {
      event.target.addEventListener('mouseleave', hideCanvas);
    }
    
    offcanvas_container_div.addEventListener('shown.bs.offcanvas', listenToMouseLeave);
  }
  
  
  //function call
  handle_the_handler('offcanvasNavigation');
  //handle_the_handler('offcanvasOptions');
  // rather annoying to use it there