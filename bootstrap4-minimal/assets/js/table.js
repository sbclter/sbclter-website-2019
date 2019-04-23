function isEmptyTable(myId){
	if(myId != ""){
		parsedId = myId.replace("table_", "")
	    let trs = document.getElementsByClassName("table_row_" + parsedId);
	    let hide = true
	    for (let element of trs) {
	      if (element.style.display !== "none"){
	      	hide = false;
	      }
	    }
	    let myTable = document.getElementById(myId);
	    let myHeader = document.getElementById("table_header_" + parsedId);
	    if (hide){
	    	myTable.style.display = 'none';
	    	myHeader.style.display = 'none';
	    } else {
	    	myTable.style.display = 'block'
	    	myHeader.style.display = 'table-header-group';
		}
	}
}

jQuery(document).ready(function($) {
    $(".clickable-row").click(function() {
    	console.log($(this).data("href"))
        window.location = $(this).data("href");
    });
    $(".clickable-row").hover(function() {
	    $(this).addClass('table-hover');
	}, function() {
	    $(this).removeClass('table-hover');
	});
});

$(document).ready(function(){
	var h3IdArr = [];

	var h3s = document.getElementsByTagName("H3");

	for(var i=0; i < h3s.length; i++)
	{
		// Will have to look for id's with table_title in future
		if(h3s[i].id.includes("table_")){
	   		h3IdArr.push(h3s[i].id);
		}
	}

  $("#myInput").on("keyup", function() {
    var value = $(this).val().toLowerCase();
    $("tbody > tr").filter(function() {
      $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
    });

    for(var i=0; i < h3IdArr.length; i++){
    	console.log(h3IdArr[i])
  		isEmptyTable(h3IdArr[i]);
  	}

  });
});
