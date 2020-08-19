// // CSV source file
const CSV_FILE = `https://erddap.sccoos.org/erddap/tabledap/autoss.csv?time,pressure,pressure_flagPrimary,temperature,temperature_flagPrimary,chlorophyll,chlorophyll_flagPrimary,salinity,salinity_flagPrimary&station=%22stearns_wharf%22&time%3E=2019-01-21T08:00:00.000Z&time%3C${ new Date().toJSON() }&orderBy(%22time%22)`;

var chart;
var timeIndex = 1;

let seriesIndex = {
    pressure: 0,
    temperature: 1,
    chlorophyll: 2,
    salinity: 3,
};

// Data configs
var units_data = {
    pressure: 'Decibars',
    temperature: '°C',
    chlorophyll: 'μg / Liter',
    salinity: 'PSU',
};


// Time until the next whole minute
let network_delay = 60000 - new Date().getTime() % 60000;

// Show graph
updateCSVData();

// Update graph periodically at every whole minute
setTimeout(() => {
    updateCSVData();

    interval = setInterval(function() {
        updateCSVData();
    }, 1000 * 60);

}, network_delay);


// ==================== Functions ======================


async function updateCSVData() {
    $('#current-time').text(formatTime(new Date()));

    fetch(CSV_FILE).then(async res => {
        let text = await res.text();

        let series = [
            {
                name: 'pressure',
                data: [],
                visible: $(`#pressure-btn`).hasClass('btn-color'),
            },
            {
                name: 'temperature',
                data: [],
                visible: $(`#temperature-btn`).hasClass('btn-color'),
            },
            {
                name: 'chlorophyll',
                data: [],
                visible: $(`#chlorophyll-btn`).hasClass('btn-color'),
            },
            {
                name: 'salinity',
                data: [],
                visible: $(`#salinity-btn`).hasClass('btn-color'),
            }
        ];

        // Parse data
        let data = text.split('\n');
        data.shift();
        data.shift();
        data.forEach(line => {
            if (line.trim().length == 0) return;

            let vals = line.split(',');
            let time = new Date(vals[0]);
            let val1 = parseFloat(vals[1]) || undefined;
            let val2 = parseFloat(vals[3]) || undefined;
            let val3 = parseFloat(vals[5]) || undefined;
            let val4 = parseFloat(vals[7]) || undefined;

            series[0].data.push([time, val1]);
            series[1].data.push([time, val2]);
            series[2].data.push([time, val3]);
            series[3].data.push([time, val4]);
        });

        pressure_data = series[0].data;
        temperature_data = series[1].data;
        chlorophyll_data = series[2].data;
        salinity_data = series[3].data;

        let isCelcius = $('.btn-temperature').hasClass('off');
        if (!isCelcius) {
            temperature_data.forEach(d => {
                d[1] = toFahrenheit(d[1]);
            });
        }

        updateLatest();

        graphData(series);
    });
}

function graphData(series) {
    Highcharts.setOptions({
        lang:{
            rangeSelectorZoom: ''
        },
    });

    Highcharts.stockChart('shore-graph', {
        credits: {
            enabled: false
        },
        chart: {
            plotBorderColor: 'black',
            plotBorderWidth: 2,
            height: '60%',
        },
        xAxis: {
            type: 'datetime',
            dateTimeLabelFormats: {
                minute:      '%l %p',
                day:         '%b %e',
                week:        '%b %e',
                month:       '%b \'%y',
                year:        '%Y'
            },
            // minorTickInterval: 5,
            // minorGridLineWidth: 1,
            tickInterval: 2,
            gridLineWidth: 1,
        },
        yAxis: {
            opposite: false,
        },
        legend: {
            enabled: false
        },
        rangeSelector: {
            selected: timeIndex,
            buttons: [{
                type: 'day',
                count: 1,
                text: '1 Day',
                dataGrouping: {
                    forced: true,
                    units: [['minute', [1]]]
                }
            },{
                type: 'week',
                count: 1,
                text: '1 Week',
                dataGrouping: {
                    forced: true,
                    units: [['minute', [1]]]
                }
            },{
                type: 'month',
                count: 1,
                text: ' 1 Month ',
                dataGrouping: {
                    forced: true,
                    units: [['hour', [1]]]
                }
            },{
                type: 'month',
                count: 3,
                text: ' 3 Month ',
                dataGrouping: {
                    forced: true,
                    units: [['hour', [1]]]
                }
            }],

            buttonTheme: {
                // fill: 'none',
                // stroke: 'none',
                // 'stroke-width': 0,
                // r: 8,
                width: 70,
                padding: 6,
                fill: '#3f51b5',
                style: {
                    color: 'white',
                    // fontWeight: 'bold'
                },
                states: {
                    hover: {
                    },
                    select: {
                        fill: '#32408f',
                        style: {
                            color: 'white',
                            fontWeight: 'normal'
                        }
                    }
                    // disabled: { ... }
                }
            }
        },
        navigator: {
            enabled: false
        },
        scrollbar: {
            enabled: false
        },
        plotOptions: {
            series: {
                showInNavigator: true
            }
        },
        tooltip: {
            formatter: function (tooltip) {
                return ['<b>' + formatTime(new Date(this.x)) + '</b>'].concat(
                    this.points ?
                        this.points.map(function (point) {
                            return point.series.name + ': ' + point.y + ' ' + units_data[point.series.name];
                        }) : []
                );
            }
        },
        series: series
    },
    function(_chart) {
        chart = _chart;
    });

    $('#graph-loader').toggleClass('hidden', true);

    $('.highcharts-range-selector-buttons .highcharts-button').click(function(e) {
        let element = $(e.target);

        while (element.prop("tagName") != 'g') {
            element = element.parent();
        }

        timeIndex = element.index() - 1;
    });
}

async function toggleGraph(topic) {
    let turnOff = $(`#${topic}-btn`).hasClass('btn-color');

    chart.series[seriesIndex[topic]].setVisible(!turnOff);
    $(`#${topic}-btn`).toggleClass('btn-color');
}

function formatTime(date) {
    return date.toLocaleString('en-US', {
        month: 'long',
        day: 'numeric',
        hour: 'numeric',
        minute: 'numeric',
        hour12: true
    });
}

function updateLatest() {
    let pressure_val = parseFloat(pressure_data[pressure_data.length - 1][1]).toFixed(2);
    let temperature_val = parseFloat(temperature_data[temperature_data.length - 1][1]).toFixed(2);
    let chlorophyll_val = parseFloat(chlorophyll_data[chlorophyll_data.length - 1][1]).toFixed(2);
    let salinity_val = parseFloat(salinity_data[salinity_data.length - 1][1]).toFixed(2);

    $('#pressure-latest')   .text(pressure_val);
    $('#temperature-latest').text(temperature_val);
    $('#chlorophyll-latest').text(chlorophyll_val);
    $('#salinity-latest')   .text(salinity_val);
}

async function toggleCelsius(e) {
    let turnOn = $(e.target).parent().hasClass('off');

    if (turnOn && units_data.temperature != '°C') {
        units_data.temperature = '°C';

        temperature_data.forEach(d => {
            d[1] = toCelsius(d[1]);
        });

        chart.series[seriesIndex.temperature].setData(temperature_data, true, true);
    }
    else if (!turnOn && units_data.temperature != '°F') {
        units_data.temperature = '°F';

        temperature_data.forEach(d => {
            d[1] = toFahrenheit(d[1]);
        });

        chart.series[seriesIndex.temperature].setData(temperature_data, true, true);
    }

    updateLatest();
}

function toCelsius(f) {
    return (f - 32) * 5 / 9;
}

function toFahrenheit(c) {
    return c * 9 / 5 + 32;
}