var stearns_wharf_csv = `https://erddap.sccoos.org/erddap/tabledap/autoss.csv?time,pressure,pressure_flagPrimary,temperature,temperature_flagPrimary,chlorophyll,chlorophyll_flagPrimary,salinity,salinity_flagPrimary&station=%22stearns_wharf%22&time%3E=2019-01-21T08:00:00.000Z&time%3C${ new Date().toJSON() }&orderBy(%22time%22)`
console.log(stearns_wharf_csv)



Plotly.d3.csv(stearns_wharf_csv, function(err, rows) {

  function unpack(rows, key) {
    return rows.map(function(row) { return row[key]; });
  }

  var pressure = {
    type: "scatter",
    mode: "lines",
    name: 'Pressure, decibars',
    x: unpack(rows, 'time'),
    y: unpack(rows, 'pressure'),
    line: {color: '#dd00dd'} /* magenta */

  }

  var temp = {
    type: "scatter",
    mode: "lines",
    name: 'Temperature, degrees Celsius (coming soon: unit option',
    x: unpack(rows, 'time'),
    y: unpack(rows, 'temperature'),
    line: {color: '#00dddd'} /* cyan */

  }

  var chl = {
    type: "scatter",
    mode: "lines",
    name: 'Chlorophyll, ~ &mu;g/liter',
    x: unpack(rows, 'time'),
    y: unpack(rows, 'chlorophyll'),
    line: {color: '#00dd00'} /* green */
  }

  var sal = {
    type: "scatter",
    mode: "lines",
    name: 'Salinity, PSU (~ ppt)',
    x: unpack(rows, 'time'),
    y: unpack(rows, 'salinity'),
    line: {color: '#ff8800'} /* orange */
  }
  
  
  

  var data = [temp, chl, pressure, sal];

  var layout = {
    title: 'Automated Shore Stations - Timeline',
    xaxis: {
      autorange: true,
      rangeselector: {buttons: [
        {
            count: 1,
            label: '1 Day',
            step: 'day',
            stepmode: 'backward'
          },
          {
            count: 7,
            label: '1 Week',
            step: 'day',
            stepmode: 'backward'
          },
       {
            count: 1,
            label: '1 Month',
            step: 'month',
            stepmode: 'backward'
          },
          {
            count: 3,
            label: '3 Months',
            step: 'month',
            stepmode: 'backward'
          }/* , */   
         /*  {
            count: 6,
            label: '6 months',
            step: 'month',
            stepmode: 'backward'
          } 
           
          {
            step: 'all'
          }
            */
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
