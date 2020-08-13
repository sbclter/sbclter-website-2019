function hideEmptyTable(table_id) {
	if (table_id == "") return;

	table_id = table_id.replace("table_", "");
	let rows = document.getElementsByClassName("table_row_" + table_id);
	let hide = true;

	for (let row of rows) {
		if (row.style.display !== "none"){
			hide = false;
		}
	}

	let myTable = document.getElementById("table_" + table_id).parentNode;
	let myHeader = document.getElementById("table_header_" + table_id);

	$(myTable).toggleClass('hidden', hide);
	myHeader.style.display = hide ? 'none' : 'table-header-group';
}

function compareRows(a, b, nth) {
	let comp = $(`td:nth-child(${ nth })`, a).text().localeCompare($(`td:nth-child(${ nth })`, b).text());
	return comp;
}

function sortTable(tbody, order, nth) {
	let asc = order === 'asc';

	tbody.find('tr').sort((a, b) => {
		let comp = compareRows(a, b, nth);
		return asc ? comp : -1 * comp;
	})
	.appendTo(tbody);
}

$(document).ready(function(){
	$(".clickable-row").click(function() {
		let url = $(this).data("href");
		if (url) window.location = url;
	});

	$(".clickable-row").hover(
		function() {
			if ($(this).data("href")) {
				$(this).addClass('table-hover');
				$(this).css('pointer-events', 'cursor');
			} else {
				$(this).css('pointer-events', 'none');
			}
		},
		function() {
			$(this).removeClass('table-hover');
			$(this).css('pointer-events', 'cursor');
		}
	);

	$('.sort-btn').click(function() {
		let nth = $(this).index() + 1;

		let tbody = $(this).closest('table').find('tbody');
		let comp = compareRows(tbody.children().first(), tbody.children().last(), nth);

		let order = comp < 0 ? 'desc' : 'asc';
		sortTable(tbody, order, nth);
	});

	$('.sort-btn').hover(
		function() {
			$(this).css('background-color', '#215384');
			let nth = $(this).index() + 1;
			let tbody = $(this).closest('table').find('tbody');

			tbody.find(`tr td:nth-child(${ nth })`).css('background-color', '#d6ffc9');
		},
		function() {
			$(this).css('background-color', '');
			let nth = $(this).index() + 1;
			let tbody = $(this).closest('table').find('tbody');

			tbody.find(`tr td:nth-child(${ nth })`).css('background-color', '');
		},);

	let table_ids = [];
	let titles = document.getElementsByClassName("table-title");

	for (let i = 0; i < titles.length; i++) {
		if (titles[i].id.includes("table_")) {
			table_ids.push(titles[i].id); 
		}
	}

	$("#search-bar").on("keyup keypress", function(e) {
		if (e.type == "keypress" && e.which != 13) {
			return;
		}

		let input = $(this).val().toLowerCase();

		if (input == '') {
			$('#bookmark-list .nav-link').removeClass('active');
			$('#bookmark-list .nav-link:first').addClass('active');
			$('.section').removeClass('active');
			$('.section:first').addClass('active');
			$('#bookmark-list').removeClass('hidden');
		}
		else {
			$('.section').addClass('active');
			$('#bookmark-list').addClass('hidden');
		}


		// Hide table rows
		$("tbody > tr").filter(function() {
			let toToggle = input.split(' ').every(inputItem => {
				const pattern = new RegExp(`(\\W|^)${ inputItem }(\\W|$)`, 'gm');
				return $(this).text().toLowerCase().search(pattern) > -1;
			});

			$(this).toggle(toToggle);
		});

		// Hide empty tables
		for (let i = 0; i < table_ids.length; i++) {
			hideEmptyTable(table_ids[i]);
		}
	});

// 	// $('table').DataTable({searching: false, paging: false, info: false});
	// $('table').DataTable();
// 		destroy: true,
// 		retrieve: true,
// 		searching: false,
// 		paging: false,
// 		info: false,
// 		// order: [[0, "desc"], [1, "desc"]],
// 	});

	$("#table-content").show();
});
