// Grey out columns by habitat or measurement type
var filter_type = "";
var is_first_search = true;

// Responsible for any changes to radio button or search
$(document).ready(function(){
	// Hide all habitats
	$("tr.data-record").hide();

	$("input[type='button']").click(function(){  // Handle button presses
		if($(this).prop("id") == "clear_button"){
			clear();
		}else{
			show_all();
		}
	});

	$("input[type='checkbox']").change(function(){  // Checkbox was changed
		if(filter_type == ""){
			// Filter_type was not set -- remember which is primary category
			filter_type = $(this).attr("name");
		}

		// Hide all habitats
		$("tr.data-record").hide();

		if(filter_type == "Habitats"){  // Run filter on habitats and then measurements
			filter_checkboxes("Habitats", "data-type-habitats",
		 	"Measurement Types", "data-type-measurementTypes");
		 	filter_checkboxes("Measurement Types", "data-type-measurementTypes",
		 	"Habitats", "data-type-habitats");
		}else{  // Run filter on measurements and then habitats
			filter_checkboxes("Measurement Types", "data-type-measurementTypes",
		 	"Habitats", "data-type-habitats");
		 	filter_checkboxes("Habitats", "data-type-habitats",
		 	"Measurement Types", "data-type-measurementTypes");
		}


	});
});

// name is the primary checkbox (i.e. one that was selected first)
// data_type_attr is the attribute name of primary checkbox type
// other_name is name for secondary type to filter by (i.e.) checkbox type not checked first)
// other_data_type_attr is attribute name for secondary checkbox type
function filter_checkboxes(name, data_type_attr, other_name, other_data_type_attr){
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

// Show all data sets
function show_all(){
	$.each($("tr.data-record"), function(){
		$(this).show();
	});
	$.each($("input[type=checkbox]"), function(){
		$(this).prop("checked", true);
	});
}

// Clear all checkbox selections
function clear(){
	$.each($("tr.data-record"), function(){
		$(this).hide();
	});
	$.each($("input[type=checkbox]"), function(){
		$(this).prop("checked", false);
	});
	filter_type = "";
	is_first_search = true;
}


// Hides elements based on the search bar
function filter_by_search(){

	// Hides values based on search query
    var value = $("#search-bar").val().toLowerCase();
    $("tbody > tr.data-record").filter(function() {  // Look for keyword in table row
      $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
    });
}