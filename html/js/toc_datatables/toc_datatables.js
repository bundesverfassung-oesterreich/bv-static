// Progressive enhancement: the XSLT-generated #tocTable is the no-JS fallback.
// With JS, DataTables replaces its body with the rows from toc.json,
// witnesses ("_children") are shown as expandable child rows.

// priority: columns with a higher number are hidden first on narrow screens
const TOC_COLUMNS = [
    { field: 'title_html', searchlist: false, priority: 1 },
    { field: 'beteiligte Personen', searchlist: false, priority: 5 },
    { field: 'Materialtyp', searchlist: true, priority: 6 },
    { field: 'Dokumententyp', searchlist: true, priority: 4 },
    { field: 'Entstehung (tpq)', searchlist: false, priority: 2 },
    { field: 'Erschließungsgrad', searchlist: true, priority: 3 }
];

// visibility of the columns as reported by the Responsive extension (true = hidden)
let hiddenColumns = TOC_COLUMNS.map(() => false);

function stripHtml(html) {
    const el = document.createElement('div');
    el.innerHTML = html || '';
    return el.textContent.trim();
}

function escapeHtml(value) {
    const el = document.createElement('div');
    el.textContent = value == null ? '' : String(value);
    return el.innerHTML;
}

function displayDate(value) {
    return String(value || '').split('|')[0];
}

function childrenText(row) {
    return (row._children || [])
        .map((child) => TOC_COLUMNS.map((c) => stripHtml(child[c.field])).join(' '))
        .join(' ');
}

function cellValue(row, col) {
    return col.field === 'Entstehung (tpq)' ? displayDate(row[col.field]) : stripHtml(row[col.field]);
}

function hasHiddenColumns() {
    return hiddenColumns.some(Boolean);
}

// Content of the expandable row: values of columns hidden on narrow screens
// plus the witnesses of the document, if any
function detailContent(row, headers) {
    let html = '';

    const hiddenItems = TOC_COLUMNS
        .map((col, i) => (hiddenColumns[i] ? `<dt>${escapeHtml(headers[i])}</dt><dd>${escapeHtml(cellValue(row, col))}</dd>` : ''))
        .join('');
    if (hiddenItems) {
        html += `<dl class="toc-details">${hiddenItems}</dl>`;
    }

    if (row._children && row._children.length) {
        const visible = TOC_COLUMNS.map((col, i) => i).filter((i) => !hiddenColumns[i]);
        const rows = row._children
            .map((child) => {
                const cells = visible.map((i) => {
                    const col = TOC_COLUMNS[i];
                    if (i !== 0) {
                        return `<td>${escapeHtml(cellValue(child, col))}</td>`;
                    }
                    const extra = TOC_COLUMNS
                        .map((c, j) => (hiddenColumns[j] ? `${escapeHtml(headers[j])}: ${escapeHtml(cellValue(child, c))}` : ''))
                        .filter(Boolean)
                        .join('; ');
                    return `<td>${child.title_html}${extra ? `<br><small>${extra}</small>` : ''}</td>`;
                });
                return `<tr>${cells.join('')}</tr>`;
            })
            .join('');
        const head = visible.map((i) => `<th scope="col">${escapeHtml(headers[i])}</th>`).join('');
        const caption = `Weitere Zeugen zu: ${escapeHtml(stripHtml(row.title_html))}`;
        html += `<table class="table table-sm toc-children"><caption>${caption}</caption>`
            + `<thead><tr>${head}</tr></thead><tbody>${rows}</tbody></table>`;
    }
    return html;
}

function searchListOptions(data, field) {
    const counts = new Map();
    data.forEach((row) => {
        const value = (row[field] || '').trim();
        if (value) {
            counts.set(value, (counts.get(value) || 0) + 1);
        }
    });
    return [...counts]
        .sort(([a, countA], [b, countB]) => countB - countA || a.localeCompare(b, 'de'))
        .map(([value, count]) => ({ label: `${value} (${count})`, value }));
}

function loadTocDataTable(dataSet) {
    fetch('./js/toc.json')
        .then((res) => res.json())
        .then((all) => {
            const data = dataSet ? all.filter((item) => item.data_set === dataSet) : all;
            data.sort((a, b) => (a.sort_key || '').localeCompare(b.sort_key || ''));
            initTocDataTable(data);
        })
        .catch((err) => console.error('toc.json could not be loaded, keeping HTML fallback', err));
}

function initTocDataTable(data) {
    const headers = [...document.querySelectorAll('#tocTable thead th')].map((th) => th.textContent.trim());

    const columns = TOC_COLUMNS.map((col, index) => {
        const label = headers[index];
        const sortContent = ['orderStatus'];

        if (col.searchlist) {
            sortContent.push({
                extend: 'dropdown',
                icon: 'search',
                iconActive: 'searchActive',
                className: 'searchlist',
                text: `Werte auswählen: ${label}`,
                content: [{ extend: 'searchList', options: searchListOptions(data, col.field) }]
            });
        }

        const column = {
            data: col.field,
            responsivePriority: col.priority,
            columnControl: [
                { target: 0, content: sortContent },
                { target: 1, content: [{ extend: 'search', placeholder: label }] }
            ]
        };

        if (col.field === 'title_html') {
            column.render = function (value, type, row) {
                if (type === 'sort') {
                    return stripHtml(value);
                }
                if (type === 'filter' || type === 'search') {
                    // witnesses are searchable through their parent row
                    return `${stripHtml(value)} ${childrenText(row)}`;
                }
                const hasWitnesses = row._children && row._children.length;
                if (type !== 'display' || !(hasWitnesses || hasHiddenColumns())) {
                    return value;
                }
                const what = hasWitnesses && hasHiddenColumns() ? 'Details und Zeugen' : hasWitnesses ? 'Zeugen' : 'Details';
                return `<button type="button" class="btn btn-sm btn-outline-secondary toc-toggle me-2"`
                    + ` aria-expanded="false" data-what="${what}"`
                    + ` data-title="${escapeHtml(stripHtml(value))}"`
                    + ` aria-label="${what} anzeigen: ${escapeHtml(stripHtml(value))}">`
                    + `<span aria-hidden="true">+</span></button>${value}`;
            };
        } else if (col.field === 'Entstehung (tpq)') {
            // prevents date type detection, which right-aligns the column
            column.type = 'string';
            column.render = function (value, type, row) {
                if (type === 'sort') {
                    return row.sort_key || '';
                }
                return displayDate(value);
            };
        }
        return column;
    });

    const table = new DataTable('#tocTable', {
        data: data,
        columns: columns,
        order: [[4, 'asc']],
        // Responsive only hides columns; the expandable rows are handled below
        responsive: { details: false },
        language: { url: 'js/datatables_custom/de-DE.json' },
        paging: false,
        layout: {
            bottomStart: null,
            bottomEnd: null
        }
    });

    table.on('draw', () => syncToggles(table));

    // re-render the toggle buttons when columns get hidden or shown
    table.on('responsive-resize', (e, api, columns) => {
        hiddenColumns = columns.map((visible) => !visible);
        table.rows().every(function () {
            this.child.hide();
        });
        table.rows().invalidate('data').draw(false);
    });

    table.on('click', 'tbody button.toc-toggle', function () {
        const row = table.row(this.closest('tr'));
        if (row.child.isShown()) {
            row.child.hide();
        } else {
            row.child(detailContent(row.data(), headers)).show();
        }
        setToggle(this, row.child.isShown());
    });
}

function setToggle(button, expanded) {
    button.setAttribute('aria-expanded', String(expanded));
    button.firstElementChild.textContent = expanded ? '−' : '+';
    button.setAttribute(
        'aria-label',
        `${button.dataset.what} ${expanded ? 'ausblenden' : 'anzeigen'}: ${button.dataset.title}`
    );
}

function syncToggles(table) {
    document.querySelectorAll('#tocTable tbody button.toc-toggle').forEach((button) => {
        setToggle(button, table.row(button.closest('tr')).child.isShown());
    });
}
