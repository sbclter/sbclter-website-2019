function isEmptyTable(myId){
	if(myId != ""){
	    let trs = document.getElementsByClassName("table_row_" + myId);
	    let hide = true
	    for (let element of trs) {
	      if (element.style.display !== "none"){
	      	hide = false;
	      }
	    }
	    let myTable = document.getElementById(myId);
	    let myHeader = document.getElementById("table_header_" + myId);
	    console.log(myHeader)
	    if (hide){
	    	myTable.style.display = 'none';
	    	myHeader.style.display = 'none';
	    } else {
	    	myTable.style.display = 'block'
	    	myHeader.style.display = 'table-header-group';
		}
	}
}

$(document).ready(function(){
	var h3IdArr = [];

	var h3s = document.getElementsByTagName("H3");

	for(var i=0;i<h3s.length;i++)
	{
		// Will have to look for id's with table_title in future
   		h3IdArr.push(h3s[i].id);
	}

  $("#myInput").on("keyup", function() {
    var value = $(this).val().toLowerCase();
    $("tbody > tr").filter(function() {
      $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
    });

    for(var i=0; i < h3IdArr.length; i++){
  		isEmptyTable(h3IdArr[i]);
  	}

  });
});
