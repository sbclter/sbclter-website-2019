const CSV_FILE = `https://erddap.sccoos.org/erddap/tabledap/autoss.csv?time,pressure,pressure_flagPrimary,temperature,temperature_flagPrimary,chlorophyll,chlorophyll_flagPrimary,salinity,salinity_flagPrimary&station=%22stearns_wharf%22&time%3E=2019-01-21T08:00:00.000Z&time%3C${ new Date().toJSON() }&orderBy(%22time%22)`;

var units_data = {
    pressure: 'Decibars',
    temperature: '°C',
    chlorophyll: '&mu;g / Liter',
    salinity: 'PSU',
};

var time_data = [];
var pressure_data = [];
var temperature_data = [];
var chlorophyll_data = [];
var salinity_data = [];

var days = 0;

var margin = {top: 10, right: 50, bottom: 50, left: 0};
var width = $(window).width() * 0.8 - margin.left - margin.right;
var height = $(window).height() * 0.7 - margin.top - margin.bottom;

var parseDate = d3.utcParse("%Y-%m-%dT%H:%M:%SZ");

var x = d3.scaleTime().range([0, width]);
var y = d3.scaleLinear().range([height, 0]);

var xAxis = d3.axisBottom(x).ticks(8);
var yAxis = d3.axisRight(y).ticks(8);
var valueline = d3.line().x(d => x(d.x)).y(d => y(d.y));

var svg = d3.select("#shore-graph")
    .classed("svg-container", true)
    .append("svg")
    .attr("viewBox", `0 0 ${width + margin.left + margin.right} ${height + margin.top + margin.bottom}`)
    .attr("preserveAspectRatio", "xMinYMin meet")
    .classed("svg-content-responsive", true)
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom);

var div = d3.select(".tooltip");

svg.append("path").attr("id", "pressure-line").attr("class", "line");
svg.append("path").attr("id", "temperature-line").attr("class", "line");
svg.append("path").attr("id", "chlorophyll-line").attr("class", "line");
svg.append("path").attr("id", "salinity-line").attr("class", "line");

svg.append("g").attr("class", "x axis").attr("transform", "translate(0," + height + ")");
svg.append("g").attr("class", "y axis").attr("transform", "translate( " + width + ", 0 )");


// svg.append("text").attr("transform", "translate(" + (width / 2) + ", " + (height + margin.top + 20) + ")")
//     .style("text-anchor", "middle")
//     .text("Time");

// svg.append("text")
//     .attr("transform", "rotate(-90)")
//     .attr("y", 0 - margin.left)
//     .attr("x", 0 - (height / 2))
//     .attr("dy", "1em")
//     .style("text-anchor", "middle")
//     .text("Value");

svg.append("g").attr("class", "grid").attr("transform", "translate(0," + height + ")")
    .call(d3.axisBottom(x).ticks(10).tickSize(-height).tickFormat(''));

svg.append("g").attr("class", "grid")
    .call(d3.axisLeft(y).ticks(10).tickSize(-width).tickFormat(''));


d3.csv(CSV_FILE).then(data => {
    data.shift();

    data.forEach((d) => {
        let time = parseDate(d.time);

        time_data.push          (time);
        pressure_data.push      ({ x: time, y: d.pressure });
        temperature_data.push   ({ x: time, y: d.temperature });
        chlorophyll_data.push   ({ x: time, y: d.chlorophyll });
        salinity_data.push      ({ x: time, y: d.salinity });
    });

    updateData($('#graph-time-range #one-month'), 30);
});

async function updateData(target, _days) {
    days = _days;
    udpateGraphData();

    $('#graph-time-range .btn').removeClass('btn-primary');
    $(target).addClass('btn-primary');
}

function udpateGraphData() {
    let end_date = time_data[time_data.length - 1];
    let start_date = new Date(end_date - 1000 * 60 * 60 * 24 * days);

    let start_i = time_data.findIndex(time => time > start_date);
    let end_i = time_data.findIndex(time => time > end_date);

    if (end_i == -1) end_i = time_data.length;

    let min_x = end_date, max_x = start_date, min_y = 0, max_y = 0;
    let i = start_i;
    for (; i < end_i; i++) {
        max_y = Math.max(max_y, pressure_data[i].y, temperature_data[i].y, chlorophyll_data[i].y, salinity_data[i].y);
        min_x = Math.min(min_x, time_data[i]);
        max_x = Math.max(max_x, time_data[i]);
    }

    x.domain([min_x, max_x]);
    y.domain([min_y, max_y + (max_y - min_y) / 10]);

    let svgt = svg.transition();

    svgt.select("#pressure-line")    .duration(500).attr("d", valueline(pressure_data    .slice(start_i, end_i)));
    svgt.select("#temperature-line") .duration(500).attr("d", valueline(temperature_data .slice(start_i, end_i)));
    svgt.select("#chlorophyll-line") .duration(500).attr("d", valueline(chlorophyll_data .slice(start_i, end_i)));
    svgt.select("#salinity-line")    .duration(500).attr("d", valueline(salinity_data    .slice(start_i, end_i)));

    svgt.select(".x.axis").duration(500).call(xAxis);
    svgt.select(".y.axis").duration(500).call(yAxis);


    $('.dots').remove();
    makeDot('pressure', pressure_data    .slice(start_i, end_i));
    makeDot('temperature', temperature_data .slice(start_i, end_i));
    makeDot('chlorophyll', chlorophyll_data .slice(start_i, end_i));
    makeDot('salinity', salinity_data    .slice(start_i, end_i));

    function makeDot(topic, data) {
        let sparse_data = [];
        let inc = Math.floor(data.length / 300);
        if (inc < 1) inc = 1;

        for (let i = 0; i < data.length; i += inc) {
            sparse_data.push(data[i]);
        }

        svg.selectAll("dot")
            .data(sparse_data)
            .enter()
            .append("circle")
                .attr("r", 7)
                .attr("class", `dots ${topic}-dots`)
                .attr("cx", d => x(d.x))
                .attr("cy", d => y(d.y))
                .attr("fill", "transparent")
                .on("mouseover", function(d) {
                    div.transition()
                        .duration(200)
                        .style("opacity", .9);
                    div.html(formatTime(d.x) + '<br/>' + parseFloat(d.y).toFixed(2) + ' ' + units_data[topic])
                        .style("left", (d3.event.pageX) + "px")
                        .style("top", (d3.event.pageY) + "px");
                    $(this).attr("fill", "black");
                    $(this).css("cursor", "pointer");
                })
                .on("mouseout", function(d) {
                    div.transition()
                    .duration(500)
                    .style("opacity", 0);
                    $(this).attr("fill", "transparent");
                    $(this).css("cursor", "unset");
                });
    }
}

async function toggleGraph(topic) {
    $(`#${topic}-btn`).toggleClass('btn-color');
    $(`#${topic}-line`).toggleClass('hide');
    $(`.${topic}-dots`).toggleClass('hide');
}

function formatTime(date) {
    return date.toLocaleString('en-US', {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        hour: 'numeric',
        minute: 'numeric',
        hour12: true
    });
}

async function toggleCelsius(e) {

    let turnOn = $(e.target).parent().hasClass('off');
    console.log($(e.target).parent().hasClass('off'));


    if (turnOn && units_data.temperature != '°C') {
        units_data.temperature = '°C';
        // $(`#temperature-btn`).text('Temperature (°C)');

        temperature_data.forEach(d => {
            d.y = toCelsius(d.y);
        });

        udpateGraphData();
    }
    else if (!turnOn && units_data.temperature != '°F') {
        units_data.temperature = '°F';
        // $(`#temperature-btn`).text('Temperature (°F)');

        temperature_data.forEach(d => {
            d.y = toFahrenheit(d.y);
        });
        udpateGraphData();
    }

}

function toCelsius(f) {
    return (f - 32) * 5 / 9;
}

function toFahrenheit(c) {
    return c * 9 / 5 + 32;
}


let network_delay = 1000 - new Date().getMilliseconds();
$('#current-time').text(formatTime(new Date()));

setTimeout(() => {
    interval = setInterval(function() {
        $('#current-time').text(formatTime(new Date()));
    }, 1000);
}, network_delay);
