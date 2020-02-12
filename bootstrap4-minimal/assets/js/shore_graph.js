var stearns_wharf_csv = `https://erddap.sccoos.org/erddap/tabledap/autoss.csv?time,pressure,pressure_flagPrimary,temperature,temperature_flagPrimary,chlorophyll,chlorophyll_flagPrimary,salinity,salinity_flagPrimary&station=%22stearns_wharf%22&time%3E=2019-01-21T08:00:00.000Z&time%3C${ new Date().toJSON() }&orderBy(%22time%22)`
console.log(stearns_wharf_csv)



Plotly.d3.csv(stearns_wharf_csv, function(err, rows) {

  function unpack(rows, key) {
    return rows.map(function(row) { return row[key]; });
  }

  var trace1 = {
    type: "scatter",
    mode: "lines",
    name: 'Pressure',
    x: unpack(rows, 'time'),
    y: unpack(rows, 'pressure'),
    line: {color: '#00dddd'}
  }

  var trace2 = {
    type: "scatter",
    mode: "lines",
    name: 'Temperature',
    x: unpack(rows, 'time'),
    y: unpack(rows, 'temperature'),
    line: {color: '#dd00dd'}
  }

  var trace3 = {
    type: "scatter",
    mode: "lines",
    name: 'Chlorophyll',
    x: unpack(rows, 'time'),
    y: unpack(rows, 'chlorophyll'),
    line: {color: '#00dd00'}
  }

  var trace4 = {
    type: "scatter",
    mode: "lines",
    name: 'Salinity',
    x: unpack(rows, 'time'),
    y: unpack(rows, 'salinity'),
    line: {color: '#ff8800'}
  }

  var data = [trace1, trace2, trace3, trace4];

  var layout = {
    title: 'Automated Shore Stations - Timeline',
    xaxis: {
      autorange: true,
      rangeselector: {buttons: [
          {
            count: 1,
            label: '1 month',
            step: 'month',
            stepmode: 'backward'
          },
          {
            count: 3,
            label: '3 months',
            step: 'month',
            stepmode: 'backward'
          },
          {
            count: 6,
            label: '6 months',
            step: 'month',
            stepmode: 'backward'
          },
          {
            step: 'all'
          }
        ]},
      type: 'date'
    },
    yaxis: {
      autorange: true,
      type: 'linear'
    }
  };

  Plotly.newPlot('myDiv', data, layout);

  $(".modebar").attr("hidden", "hidden");
})