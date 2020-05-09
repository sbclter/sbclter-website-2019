// Grey out columns by habitat or measurement type
var primary_filter = "";
var is_first_search = true;
var FILTER = {
	HABITAT: {
		name: "Habitats",
		attr: "data-type-habitats"
	},
	MEASUREMENT: {
		name: "Measurement Types",
		attr: "data-type-measurementTypes"
	},
	AREA: {
		name: "LTER Core Research Areas",
		attr: "data-type-ltercoreresearchareas"
	}
};
var current_filter = undefined;

// Responsible for any changes to radio button or search
$(document).ready(function(){

	// Hide all habitats
	$("tr.data-record").hide();

	// Handle all/clear button presses
	$("button[type='button']").click(function() {
		if($(this).prop("id") == "clear_button"){
			clear();
		}else{
			show_all();
		}
	});

	// Handle habitat and measurement filter changes
	$("input[type='checkbox'][group='Hab-Meas']").change(function() {
		
		// We're filtering by habitat and measure so disable the research areas boxes
		$("input[group='Areas']").each(function() {
			$(this).prop("checked", false);
		});

		// Clear area checkboxes
		if (current_filter && current_filter != FILTER.HABITAT) {
			clear();
			$(this).prop("checked", true);
		}
		current_filter = FILTER.HABITAT;

		// Initialize primary filter (can change after clicking reset button)
		if (primary_filter == "") {
			primary_filter = $(this).attr("name");
		}

		// Select filters based on primary filter
		if(primary_filter == FILTER.HABITAT.name) {
			select_related_filters(FILTER.HABITAT, FILTER.MEASUREMENT);
		}
		else {
			select_related_filters(FILTER.MEASUREMENT, FILTER.HABITAT);
		}

		// Apply filter on collections data
		apply_filters();

		// Enable secondary checkboxes when no primary filter is selected
		if ($(`input[name='${ primary_filter }']:checked`).length == 0) {
			clear();
		}
	});

	// Handle area filter changes
	$("input[type='checkbox'][group='Areas']").change(function() {

		// We're filtering by area so disable the habitat/measurement buttons
		$.each($("input[group='Hab-Meas']"), function(){
			$(this).prop("checked", false);
		})

		// Clear habitat checkboxes
		if (current_filter && current_filter != FILTER.AREA) {
			clear();
			$(this).prop("checked", true);
		}
		current_filter = FILTER.AREA;

		// Apply filter on collections data
		apply_filters();
	});
});

// Apply filter (habitat, measurement, area) on collections data
function apply_filters() {
	// Hide all collections data
	$("tr.data-record").hide();

	let h_filters = new Set();
	let m_filters = new Set();
	let a_filters = new Set();
	let no_data = true;

	// Save selected filters into corresponding set
	$(`input[name='${FILTER.HABITAT.name}']`).each(function() {
		if($(this).is(':checked'))
			h_filters.add($(this).val());
	});
	$(`input[name='${FILTER.MEASUREMENT.name}']`).each(function() {
		if($(this).is(':checked'))
			m_filters.add($(this).val());
	});
	$(`input[name='${FILTER.AREA.name}']`).each(function() {
		if($(this).is(':checked'))
			a_filters.add($(this).val());
	});

	// Apply filter on collections data
	$.each($("tr.data-record"), function() {
		let h_tags = $(this).attr(FILTER.HABITAT.attr).split("-");
		let m_tags = $(this).attr(FILTER.MEASUREMENT.attr).split("-");
		let a_tags = $(this).attr(FILTER.AREA.attr).split("-");

		// Check if each tag satisfies the filters
		let h_satisfied = h_tags.some((tag) => h_filters.has(tag));
		let m_satisfied = m_tags.some((tag) => m_filters.has(tag));
		let a_satisfied = a_tags.some((tag) => a_filters.has(tag));

		// Actual filtering logic
		if ((h_satisfied && m_satisfied) || a_satisfied) {
			$(this).show();
			no_data = false;
		}
	});

	$('#display-container').toggleClass('hide', no_data);
}

// Select related filters based on primary filter
function select_related_filters(primary_filter, other_filter){
	// Store the types of measurements that overlap with the selected habitats
	let related_filters = []

	// Collect related filters for each selected primary filter
	$(`input[name='${ primary_filter.name }']:checked`).each(function(){
		$(`tr.data-record[${ primary_filter.attr }*='${ $(this).val() }']`).each(function() {
			// Parse and filter the measurement attributes
			related_filters += $(this).attr(other_filter.attr).split("-").filter(function(item) {
				return item != "" && !related_filters.includes(item);
			});
		});
	});

	$.each($("input[name='" + other_filter.name + "']"), function(){
		if(!related_filters.includes($(this).val())){
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
	is_first_search = false;
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
	$('#display-container').toggleClass('hide', false);
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
	primary_filter = "";
	is_first_search = true;
	$('#display-container').toggleClass('hide', true);
}
