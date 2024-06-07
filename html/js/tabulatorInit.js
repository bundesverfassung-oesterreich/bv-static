let paginatorOptions = {
  layout: "fitColumns",
  responsiveLayout: "collapse",
  paginationCounter: "rows",
  // langs: {
  //   default: {
  //     pagination: {
  //       counter: {
  //         showing: "",
  //         of: "von",
  //         rows: "",
  //       },
  //       pages: "pages",
  //       page_size: "Seitengröße", //label for the page size select element
  //       page_title: "Zeige Seite", //tooltip text for the numeric page button, appears in front of the page number (eg. "Show Page" will result in a tool tip of "Show Page 1" on the page 1 button)
  //       first: "Erste", //text for the first page button
  //       first_title: "Erste", //tooltip text for the first page button
  //       last: "Letzte",
  //       last_title: "Letzte",
  //       prev: "zurück",
  //       prev_title: "zurück",
  //       next: "vor",
  //       next_title: "vor",
  //       all: "alle",
  //     },
  //   },
  // },
  columns: [
    {
      headerFilter: "input",
      title: "Titel",
      field: "Titel",
      formatter: "html",
      minWidth: 500,
    },
    {
      headerFilter: "input",
      title: "beteiligte Personen",
      field: "beteiligte Personen",
      formatter: "html",
      minWidth: "300",

    },
    {
      headerFilter: "list",
      headerFilterParams: { valuesLookup: true, clearable: true },
      title: "Dokumententyp",
      field: "Dokumententyp",
      minWidth: "200",

    },
    {
      headerFilter: "list",
      headerFilterParams: { valuesLookup: true, clearable: true },
      title: "Materialtyp",
      field: "Materialtyp",
      minWidth: "200",

    },
    {
      title: "Entstehung (tpq)",
      field: "Entstehung (tpq)",
      minWidth: "100",

    },
    {
      title: "Erschließungsgrad",
      field: "Erschließungsgrad",
      headerFilter: "list",
      headerFilterParams: { valuesLookup: true, clearable: true },
    },
  ],
};
var table = new Tabulator("#tocTable", paginatorOptions);
/*
one could add a function to give a count of the total entrys, regardless of filter events
table.on("renderComplete", function(){
    let doc_counter = document.getElementById("doccounter");
    let footer = table.footerManager.element ;
});*/
