let tabulatorCfg = {
  layout: "fitColumns",
  responsiveLayout: "collapse",
  paginationCounter: "rows",
  dataTree: true,
  dataTreeStartExpanded: false,

  columns: [
    {
      headerFilter: "input",
      title: "Title",
      field: "title_html",
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
      title: "Dokumententyp",
      field: "Dokumententyp",
      headerFilterParams: { valuesLookup: true, clearable: true },
      minWidth: "200",
    },
    {
      title: "Materialtyp",
      field: "Materialtyp",
      minWidth: "200",
      headerFilter: "list",
      headerFilterParams: { valuesLookup: true, clearable: true },
    },
    {
      headerFilter: "input",
      title: "Entstehung (tpq)",
      field: "Entstehung (tpq)",
      minWidth: "100",
    },
    {
      title: "Erschlie\u00dfungsgrad",
      field: "Erschlie\u00dfungsgrad",
      headerFilter: "list",
      headerFilterParams: { valuesLookup: true, clearable: true },
    },
  ],
 };

fetch("./js/toc.json")
  .then((res) => res.json())
  .then((data) => {
    // clear the table before adding new data
    var element = document.getElementById("tocTable");
    if (element) {
      while (element.firstChild) {
        element.removeChild(element.firstChild);
      }
    }
    tabulatorCfg.data = data;
    var table = new Tabulator("#tocTable", tabulatorCfg);
  });

/*
one could add a function to give a count of the total entrys, regardless of filter events
table.on("renderComplete", function(){
    let doc_counter = document.getElementById("doccounter");
    let footer = table.footerManager.element ;
});*/
