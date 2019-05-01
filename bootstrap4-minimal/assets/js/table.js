
// Searches the page for a table with id "myId"
// It will check each row of the table for the id parsed from myId
// If all rows are hidden, then the table is empty and should be hidden
function isEmptyTable(myId){
	if(myId != ""){
		// Parse id to look at row id's
		parsedId = myId.replace("table_", "")

	    let trs = document.getElementsByClassName("table_row_" + parsedId);
	    let hide = true
	    // Look through all table rows
	    for (let element of trs) {
	      if (element.style.display !== "none"){
	      	hide = false;
	      }
	    }

	    let myTable = document.getElementById(myId).parentNode;
	    let myHeader = document.getElementById("table_header_" + parsedId);
	    if (hide){  // Hide the table
	    	myTable.style.display = 'none';
	    	myHeader.style.display = 'none';
	    }
	    else {  // Unhide the table
	    	myTable.style.display = 'block'
	    	myHeader.style.display = 'table-header-group';
		}
	}
}

// Simple function for adding custom styling when hovering a table row
jQuery(document).ready(function($) {
    $(".clickable-row").click(function() {
        window.open($(this).data("href"), '_blank');
    });
    $(".clickable-row").hover(function() {
	    $(this).addClass('table-hover');
	}, function() {
	    $(this).removeClass('table-hover');
	});
});

// Search the tables on the page for the input to the search bar
// Handles searching multiple tables and hides empty tables
$(document).ready(function(){
	var h3IdArr = [];

	var h3s = document.getElementsByClassName("table-title");

	for(var i=0; i < h3s.length; i++)
	{
		// Will have to look for id's with table_title in future
		if(h3s[i].id.includes("table_")){
			// Gets titles for all tables on page to search
	   		h3IdArr.push(h3s[i].id); 
		}
	}

  $("#search-bar").on("keyup", function() {
    var value = $(this).val().toLowerCase();
    $("tbody > tr").filter(function() {  // Look for keyword in table row
      $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
    });

    for(var i=0; i < h3IdArr.length; i++){
  		isEmptyTable(h3IdArr[i]);  // Hide empty tables
  	}

  });
});
