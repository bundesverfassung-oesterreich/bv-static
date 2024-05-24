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
          css_class: "test_class",
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
          opt: "prs",
          color: "blue",
          title: "Personen",
          html_class: "persons",
          css_class: "pers",
          hide: {
            hidden: false,
            class: "persons .entity",
          },
          chg_citation: "citation-url",
          features: {
            all: false,
            class: "features-1",
          },
        },
        {
          opt: "org",
          color: "yellow",
          //title: "Organizations",
          title: "Organisationen",
          html_class: "orgs",
          css_class: "org",
          hide: {
            hidden: false,
            class: "orgs .entity",
          },
          chg_citation: "citation-url",
          features: {
            all: false,
            class: "features-1",
          },
        },
        {
          opt: "wrk",
          color: "lila",
          //title: "Works",
          title: "Werke",
          html_class: "works",
          css_class: "wrk",
          chg_citation: "citation-url",
          hide: {
            hidden: false,
            class: "wrk .entity",
          },
          features: {
            all: false,
            class: "features-1",
          },
        }
      ],
      span_element: {
        css_class: "badge-item",
      },
      active_class: "activated",
      rendered_element: {
        label_class: "switch",
        slider_class: "i-slider round",
      },
    },
    fos: {
      name: "Change font size",
      variants: [
        {
          opt: "fs",
          //title: "Font Size",
          title: "Schriftgröße",
          urlparam: "fs",
          chg_citation: "citation-url",
          sizes: {
            default: "default",
            font_size_14: "14",
            font_size_18: "18",
            font_size_22: "22",
            font_size_26: "26",
          },
          paragraph: ".yes-index",
          p_class: "",
          css_class: "font-size-",
        },
      ],
      active_class: "active",
      html_class: "form-select",
    },
    wr: false,
    up: true,
  });
  