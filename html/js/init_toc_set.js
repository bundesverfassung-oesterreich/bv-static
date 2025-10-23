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
      formatter: function (cell, formatterParams) {
        var v = cell.getValue();
        if (!v) return "";
        // value format: ISO|sortkey (e.g. 1919-05-01|0600)
        return String(v).split("|")[0] || "";
      },
      sorter: function (a, b, aRow, bRow, column, dir, sorterParams) {
        function parseKey(v) {
          if (!v) return ["", 0];
          var parts = String(v).split("|");
          var date = parts[0] || ""; // ISO date, safe for lexical compare
          var key = parts[1] || "0";
          // try numeric comparison for the sort key
          var num = parseInt(key, 10);
          if (isNaN(num)) num = 0;
          return [date, num];
        }

        var pa = parseKey(a);
        var pb = parseKey(b);

        if (pa[0] < pb[0]) return -1;
        if (pa[0] > pb[0]) return 1;
        return pa[1] - pb[1];
      },
      // ensure header filtering still works on the raw string
      headerFilterPlaceholder: "YYYY-MM-DD",
    },
    {
      title: "Erschlie\u00dfungsgrad",
      field: "Erschlie\u00dfungsgrad",
      headerFilter: "list",
      headerFilterParams: { valuesLookup: true, clearable: true },
    },
  ],
};

function loadTocForDataSet(data_set) {
  fetch("./js/toc.json")
    .then((res) => res.json())
    .then((data) => {
      // clear the table before adding new data
      var table = document.getElementById("tocTable");
      var tableContainer = document.createElement("div");
      table.parentNode.replaceChild(tableContainer, table);
      tableContainer.id = "tocTable";
      if (!data_set) {
        tabulatorCfg.data = data;
      } else {
        tabulatorCfg.data = data.filter((item) => item["data_set"] === data_set);
      }
      // sort the data; key is the sorter
      tabulatorCfg.data.sort((a, b) => a.sort_key.localeCompare(b.sort_key));
      var table = new Tabulator("#tocTable", tabulatorCfg);
    });
}
// export { loadTocForDataSet };
/*
one could add a function to give a count of the total entrys, regardless of filter events
table.on("renderComplete", function(){
    let doc_counter = document.getElementById("doccounter");
    let footer = table.footerManager.element ;
});*/
