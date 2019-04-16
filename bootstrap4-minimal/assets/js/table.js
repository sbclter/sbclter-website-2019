function isEmptyTable(myId){
	if(myId != ""){
	    let trs = document.getElementsByClassName(myId);
	    let hide = true
	    for (let element of trs) {
	      if (element.style.display !== "none"){
	      	hide = false;
	      }
	    }
	    let myTable = document.getElementById(myId);
	    if (hide) myTable.style.display = 'none';
	    else myTable.style.display = 'block'
	
	}
}

$(document).ready(function(){
	var idArr = [];

	var h3s = document.getElementsByTagName("H3");

	for(var i=0;i<h3s.length;i++)
	{
		// Will have to look for id's with table_title in future
   		idArr.push(h3s[i].id);
	}
  $("#myInput").on("keyup", function() {
    var value = $(this).val().toLowerCase();
    $("tr").filter(function() {
      $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
    });

    for(var i=0; i < idArr.length; i++){
  		isEmptyTable(idArr[i]);
  	}
  });




});
