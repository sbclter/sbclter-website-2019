// Code to take user from the data catalog page to the data search page
// by simply redirecting to the other page with with url fields set
// to default to first search on that page
function do_search(){

	$('#search-bar').on("keydown",function search(e) {
	    if(e.keyCode == 13) {
	        search_helper()
	    }
	});

	$("#search-bar-button").click(function(){
		search_helper()
	})
}

// Helper function for redirecting to search page
function search_helper(){
	val = $('#search-bar').val();
	dataset_search_url = window.location.origin + "/data/catalog/search/?sort=score&q=" + 
								val + "&coreArea=any&creator=&s=1900&e=2019&id=&taxon=&geo="
	window.location.replace(dataset_search_url);

}

$(document).ready(function(){
	// Search bar function
	do_search();
});
