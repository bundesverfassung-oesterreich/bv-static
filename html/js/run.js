var editor = new LoadEditor({
  aot: {
    title: "Text Annotations",
    variants: [
      {
        opt: "ef",
        opt_slider: "entities-features-slider",
        title: "Alles",
        color: "red",
        html_class: "undefined",
        css_class: "undefined",
        chg_citation: "citation-url",
        hide: {
          hidden: false,
          class: "undefined",
        },
        features: {
          all: true,
          class: "features-1",
        },
      },
      {
        opt: "historical_pagecounter",
        color: "grey",
        title: "historische Paginierung/Foliierung",
        html_class: "historical_pagecounter",
        css_class: "hpc_visible",
        hide: {
          hidden: true,
          class: "historical_pagecounter",
        },
        chg_citation: "citation-url",
        features: {
          all: false,
          class: "features-1",
        },
      },
      {
        opt: "comment_toggler",
        color: "grey",
        title: "historische Metatexte",
        html_class: "meta_text",
        css_class: "display_comment",
        hide: {
          hidden: true,
          class: "meta_text",
        },
        chg_citation: "citation-url",
        features: {
          all: false,
          class: "features-1",
        },
      },
      {
        opt: "genetic_toggler",
        color: "blue",
        title: "Änderungen",
        html_class: "text_genetic",
        css_class: "genetic_view",
        chg_citation: "citation-url",
        features: {
          all: false,
          class: "features-1",
        },
      },
      {
        opt: "correction_toggler",
        color: "",
        title: "editorische Korrekturen",
        html_class: "corr",
        css_class: "correction_view",
        chg_citation: "citation-url",
        features: {
          all: false,
          class: "features-1",
        },
      },
    ],
    span_element: {
      css_class: "badge-item",
    },
    active_class: "active",
    rendered_element: {
      label_class: "switch",
      slider_class: "i-slider round",
    },
  },
  fos: {
    name: "Change font size",
    variants: [
      {
        // must match opt attribute value of custom element
        opt: "fos",
        // visible feature title
        title: "Schriftgröße",
        // url parameter name
        urlparam: "fontsize",
        // custom class for citation link
        chg_citation: "citation-url",
        // default font sizes
        sizes: {
          default: "default",
          font_size_14: "14",
          font_size_18: "18",
          font_size_22: "22",
          font_size_26: "26",
        },
        // default tag-name containing text
        paragraph: "div",
        // default class in combination with paragraph that contains text
        p_class: "",
        // default addition to css class. Will be combined with font size value
        css_class: "font-size-",
      },
    ],
  },
});
