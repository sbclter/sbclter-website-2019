// Filtering values selected (one from each category)
var habitat = "All Habitats";
var measurement_type = "All Measurement Types";
var research_area = "All Research Areas";


$(document).ready(function(){
	$("input[type='radio']").change(function(){

		// Show all habitats
		$("tr.data-record").show();

		// Filter results
		filter_by_search();
		filter_by_radio();
	});

	$("#search-bar").on("keyup", function() {

		// Show all habitats
		$("tr.data-record").show();

		// Filter results
		filter_by_search();
	    filter_by_radio();
  	});
});

// Hides elements based on the radio buttons
function filter_by_radio(){
	// A change was made to one of the radio buttons, get updated values ...
	habitat = $("input[name='Habitats']:checked").val();
	measurement_type = $("input[name='Measurement Types']:checked").val();
	research_area = $("input[name='LTER Core Research Areas']:checked").val();

	// Use the updated values to filter the tables
	// Show only the entries matching our selected filter terms for habitat
	if(habitat != "All Habitats"){
		$("tr.data-record").not("[data-type-habitats~='" + 
			parse_habitat(habitat) + "']").hide();
	}
	if(measurement_type != "All Measurement Types"){
		$("tr.data-record").not("[data-type-measurementtypes~='" + 
			parse_measurement(measurement_type) + "']").hide();
	}
	if(research_area != "All Research Areas"){
		$("tr.data-record").not("[data-type-ltercoreresearchareas~='" + 
			parse_research(research_area) + "']").hide();
	}
}

// Hides elements based on the search bar
function filter_by_search(){

	// Hides values based on search query
    var value = $("#search-bar").val().toLowerCase();
    $("tbody > tr.data-record").filter(function() {  // Look for keyword in table row
      $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
    });
}


// Map from the filter names to the database habitat names
function parse_habitat(habitat){
	habitat = habitat.toLowerCase();

	// These names are slightly different between database and actual filter title
	if(habitat == "reef/kelp forest"){
		return "reef";
	}else if(habitat == "inshore ocean"){
		return "nearshore";
	}else if(habitat == "offshore ocean"){
		return "offshore";
	}else{  // No special term -- just lowercase
		return habitat; 
	}
}

// Map from filter's name to the proper database measurement name
// Make it lowercase and replace the space with an underscore
function parse_measurement(measurement){
	return measurement.toLowerCase().replace(" ", "_");
}

// Map from filter's name to the proper database research area name
// Just needs to be lowercase
function parse_research(area){
	return area.toLowerCase();
}