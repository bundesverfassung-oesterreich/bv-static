// toggle short doc title when scrolling

const shortTitle = document.getElementById("short_title");
const documentMetadata = document.getElementById("edition_metadata");

// Check if shortTitle and documentMetadata exist
if (shortTitle && documentMetadata) {
    const viewportObserver = new IntersectionObserver(
        entries => {
            // Check if documentMetadata is visible
            if (!entries[0].isIntersecting) {
                // if not toggle shortTitle
                shortTitle.classList.add("display_title");
                console.log("chiao");
            } else {
                shortTitle.classList.remove("display_title");
                console.log("hello");
            }
        },
        options = {
            threshold: 0.1,
        }
    );
    // Observe the documentMetadata element
    viewportObserver.observe(documentMetadata);
} else {
    console.error("Element(s) not found: shortTitle or documentMetadata");
}
