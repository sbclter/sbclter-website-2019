// Filtering values selected (one from each category)
var habitat = "";
var measurement_type = "";
var research_area = "";


$(document).ready(function(){
	$("input[type='radio']").change(function(){
		// A change was made to one of the radio buttons, get updated values ...
		habitat = $("input[name='Habitats']:checked").val();
		measurement_type = $("input[name='Measurement Types']:checked").val();
		research_area = $("input[name='LTER Core Research Areas']:checked").val();

		// Show all habitats
		$("tr.data-record").show();

		// Use the updated values to filter the tables
		// Show only the entries matching our selected filter terms for habitat
		if(habitat != undefined && habitat != "All Habitats"){
			console.log(habitat);
			$("tr.data-record").not("[data-type-habitats~='" + 
				parse_habitat(habitat) + "']").hide();
		}
		if(measurement_type != undefined && measurement_type != "All Measurement Types"){
			console.log(measurement_type);
			$("tr.data-record").not("[data-type-measurementtypes~='" + 
				parse_measurement(measurement_type) + "']").hide();
		}
		if(research_area != undefined && research_area != "All Research Areas"){
			console.log(research_area);
			$("tr.data-record").not("[data-type-ltercoreresearchareas~='" + 
				parse_research(research_area) + "']").hide();
		}
	});
});

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