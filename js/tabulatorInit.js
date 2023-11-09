let paginatorOptions = {
    pagination:true,
    paginationSize:10,
    layout: "fitColumns",
    responsiveLayout:"hide",
    columns: [
        {
            headerFilter: "input",
            title: "Titel",
            field: "Titel",
            formatter: function (cell) {
                return cell.getValue();
            },
        },
        {
            headerFilter: "input",
            title: "beteiligte Personen",
            field: "beteiligte Personen",
            formatter: function (cell) {
                return cell.getValue();
            },
        },
        {
            headerFilter: "input",
            title: "Dokumententyp",
            field: "Dokumententyp",
        },
        {
            headerFilter: "input",
            title: "Materialtyp",
            field: "Materialtyp",
        },
        {
            title: "Entstehung (tpq)",
            field: "Entstehung (tpq)",
        }
    ]
}
var table = new Tabulator("#tocTable", paginatorOptions);