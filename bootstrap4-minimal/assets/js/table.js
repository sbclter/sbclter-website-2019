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

function sortTable(tbody, order) {
	let asc   = order === 'asc';

	tbody.find('tr').sort(function(a, b) {
		// console.log($('td:first', a).text());
		// console.log($('td:first', b).text());
		let comp = parseInt($('td:first', a).text()) - parseInt($('td:first', b).text());
		// console.log(comp);
		return asc ? comp : -1 * comp;
	})
	.appendTo(tbody);
}

$(document).ready(function(){
	$(".clickable-row").click(function() {
		window.location = $(this).data("href");
	});

	$(".clickable-row").hover(
		function() {
			$(this).addClass('table-hover');
		},
		function() {
			$(this).removeClass('table-hover');
		}
	);

	$('.sort-btn').parent().click((e) => {
		let tbody = $(e.target).closest('table').find('tbody');
		let order = tbody.attr('order') == 'asc' ? 'desc' : 'asc';
		tbody.attr('order', order);
		sortTable(tbody, order);
	});

	let table_ids = [];
	let titles = document.getElementsByClassName("table-title");

	for (let i = 0; i < titles.length; i++) {
		if (titles[i].id.includes("table_")) {
			table_ids.push(titles[i].id); 
		}
	}

	$("#search-bar").on("keyup", function() {
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
			$(this).toggle($(this).text().toLowerCase().indexOf(input) > -1)
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
