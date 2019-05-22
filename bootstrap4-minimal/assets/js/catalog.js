// Grey out columns by habitat or measurement type
var filter_type = "";
var is_first_search = true;

// Responsible for any changes to radio button or search
$(document).ready(function(){
	// Hide all habitats
	$("tr.data-record").hide();

	$("button[type='button']").click(function(){  // Handle button presses
		if($(this).prop("id") == "clear_button"){
			clear();
		}else{
			show_all();
		}
	});

	$("input[type='checkbox'][group='Hab-Meas']").change(function(){  // Checkbox was changed
		
		// We're filtering by habitat and measure so disable the research areas boxes
		$.each($("input[group='Areas']"), function(){
			$(this).prop("checked", false);
			$(this).prop("disabled", true);
		})

		if(filter_type == ""){
			// Filter_type was not set -- remember which is primary category
			filter_type = $(this).attr("name");
		}

		// Hide all habitats
		$("tr.data-record").hide();

		if(filter_type == "Habitats"){  // Run filter on habitats and then measurements
			filter_hab_meas_checkboxes("Habitats", "data-type-habitats",
		 	"Measurement Types", "data-type-measurementTypes");
		 	filter_hab_meas_checkboxes("Measurement Types", "data-type-measurementTypes",
		 	"Habitats", "data-type-habitats");
		}else{  // Run filter on measurements and then habitats
			filter_hab_meas_checkboxes("Measurement Types", "data-type-measurementTypes",
		 	"Habitats", "data-type-habitats");
		 	filter_hab_meas_checkboxes("Habitats", "data-type-habitats",
		 	"Measurement Types", "data-type-measurementTypes");
		}
	});
	$("input[type='checkbox'][group='Areas']").change(function(){  // Checkbox was changed
		// We're filtering by area so disable the habitat/measurement buttons
		$.each($("input[group='Hab-Meas']"), function(){
			$(this).prop("checked", false);
			$(this).prop("disabled", true);
		})

		filter_areas_checkboxes("LTER Core Research Areas", "data-type-ltercoreresearchareas");
	});
});

// name is the primary checkbox (i.e. one that was selected first)
// data_type_attr is the attribute name of primary checkbox type
// other_name is name for secondary type to filter by (i.e.) checkbox type not checked first)
// other_data_type_attr is attribute name for secondary checkbox type
function filter_hab_meas_checkboxes(name, data_type_attr, other_name, other_data_type_attr){
	// Store the types of measurements that overlap with the selected habitats
	let possible_categories = []

	// Measurements were selected first, simply look at checked habitats and filter
	$.each($("input[name='" + name + "']"), function(){
		if($(this).is(':checked')){			
			// Checked, show all its corresponding table rows
			$.each($("tr.data-record[" + data_type_attr + "*='" + $(this).val() + "']"), function(){
				$(this).show();
				if(filter_type == name){  // Only if primary filter
					// Parse and filter the measurement attributes
					possible_categories += $(this).attr(other_data_type_attr).split("-").filter(function(item) {
						return item != "" && !possible_categories.includes(item);
					});
				}
			});
		}else{
			$.each($("tr.data-record[" + data_type_attr + "*='" + $(this).val() + "']"), function(){
				$(this).hide();
			});
		}
	});

	if(filter_type == name){  // Only if primary filter
		// Grey out boxes in measurements that have no overlap with selected habitats
		$.each($("input[name='" + other_name + "']"), function(){
			if(!possible_categories.includes($(this).val())){
				// No selected habitat sets exist with this measurement type
				$(this).prop("checked", false);
				$(this).prop("disabled", true); // Disable this checkbox
			}else{
				if($(this).prop("disabled") || is_first_search){
					// It was disabled, enable it and check it
					$(this).prop("disabled", false);  // Enable the checkbox
					$(this).prop("checked", true);
				}

			}
		});
	}
	is_first_search = false;
}

// Function to show hide table row elements based on which elements of the
// Research areas table are checked
function filter_areas_checkboxes(name, data_type_attr){
	// Measurements were selected first, simply look at checked habitats and filter
	$.each($("input[name='" + name + "']"), function(){
		if($(this).is(':checked')){			
			// Checked, show all its corresponding table rows
			$.each($("tr.data-record[" + data_type_attr + "*='" + $(this).val() + "']"), function(){
				$(this).show();
			});
		}else{
			$.each($("tr.data-record[" + data_type_attr + "*='" + $(this).val() + "']"), function(){
				$(this).hide();
			});
		}
	});
}

// Show all data sets
function show_all(){
	$.each($("tr.data-record"), function(){
		$(this).show();
	});
	$.each($("input[type=checkbox]"), function(){
		$(this).prop("checked", true);
		$(this).prop("disabled", false);
	});
}

// Clear all checkbox selections
function clear(){
	$.each($("tr.data-record"), function(){
		$(this).hide();
	});
	$.each($("input[type=checkbox]"), function(){
		$(this).prop("checked", false);
		$(this).prop("disabled", false);
	});
	filter_type = "";
	is_first_search = true;
}
