let paginatorOptions = {
    pagination:true,
    paginationSize:15,
    layout: "fitDataStretch",
    responsiveLayout:"collapse",
    columns: [
        {
            headerFilter: "input",
            title: "Titel",
            field: "Titel",
            formatter: "html"
        },
        {
            headerFilter: "input",
            title: "beteiligte Personen",
            field: "beteiligte Personen",
            formatter: "html"
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