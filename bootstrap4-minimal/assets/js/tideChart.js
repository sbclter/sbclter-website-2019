async function fetchTideData() {
    const station = '9411340'; // Example station ID
    const now = new Date();
    const beginDate = new Date(now);
    beginDate.setDate(now.getDate() - 1); // Yesterday
    const endDate = new Date(now);
    endDate.setDate(now.getDate() + 2); // 3 days later

    const formatDate = date => date.toISOString().split('T')[0].replace(/-/g, '');
    
    const beginDateString = formatDate(beginDate);
    const endDateString = formatDate(endDate);

    const url = `https://api.tidesandcurrents.noaa.gov/api/prod/datagetter?product=predictions&application=NOS.COOPS.TAC.WL&begin_date=${beginDateString}&end_date=${endDateString}&datum=MLLW&station=${station}&time_zone=lst_ldt&units=english&interval=h&format=json`;

    try {
        const response = await fetch(url);
        const data = await response.json();
        console.log('Fetched Data:', data); // Debugging output
        return data.predictions;
    } catch (error) {
        console.error('Error fetching tide data:', error);
    }
}

function plotTideData(predictions) {
    if (!predictions || predictions.length === 0) {
        console.error('No data to plot.');
        return;
    }

    const labels = predictions.map(prediction => prediction.t.replace(' ', 'T'));
    const data = predictions.map(prediction => parseFloat(prediction.v));

    console.log('Labels:', labels); // Debugging output
    console.log('Data:', data); // Debugging output

    const now = new Date();

    const ctx = document.getElementById('tideChart').getContext('2d');
    new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                data: data,
                borderColor: 'rgba(75, 192, 192, 1)',
                backgroundColor: 'rgba(75, 192, 192, 0.2)',
                borderWidth: 1,
                fill: true,
                tension: 0.1
            }]
        },
        options: {
         scales: {
                x: {
                    type: 'time',
                    time: {
                        tooltipFormat: 'MMM d, ha',
                        unit: 'hour',
                        displayFormats: {
                            hour: 'ha', // Display only the hour on the first line
                        }
                    },
                    ticks: {
                          major: {
                         enabled: true
                    },
                      source: 'auto',
                    autoSkip: false,
                 maxRotation: 0,
                       font: {
                        size: 14, // Increase label size (adjust the size as needed)
                     },
                     color: 'black', // Set the tick label color to black
                        callback: function(value, index, ticks) {
                            // Show time on the first line and date on the second line
                            const tickDate = new Date(ticks[index].value);
                            const hour = tickDate.getHours();
                            if (hour === 0 || hour === 12 || hour === 6 || hour === 18) {
                                return [
                                    tickDate.toLocaleString('en-US', { 
                                        hour: 'numeric', 
                                        hour12: true 
                                    }), 
                                    tickDate.toLocaleString('en-US', { 
                                        month: 'short', 
                                        day: '2-digit' 
                                    }).replace(',', '')
                                ];
                            }
                            return null; // Hide other ticks
                        },
                    },
                    grid: {
                        color: function(context) {
                            const tickDate = new Date(context.tick.value);
                            const hour = tickDate.getHours();
                            if (hour === 0 || hour === 12 || hour === 6 || hour === 18) {
                                return 'rgba(0, 0, 0, 0.1)'; // Darker color for major grid lines
                            } else {
                                return 'rgba(0, 0, 0, 0.1)'; // Lighter color for minor grid lines
                            }
                        },
                        lineWidth: function(context) {
                            const tickDate = new Date(context.tick.value);
                            const hour = tickDate.getHours();
                            return (hour === 0 || hour === 12 || hour === 6 || hour === 18) ? 2 : 1; // Thicker lines for major grid lines
                        },
                    },
                },
                y: {
                    beginAtZero: false,
                    title: {
                        display: true,
                        text: 'Tide Level, MLLW (feet)',
                        font: {
                            size: 16,
                            weight: 'bold' // Make the y-axis label larger and bold
                        }
                    },
                    ticks: {
            font: {
                size: 18, // Increase label size for y-axis
            },
            color: 'black', // Set the tick label color to black for y-axis
        },
                    grid: {
                        drawTicks: true,
                        drawBorder: false,
                    }
                }
            },
            plugins: {
                legend: {
                    display: false // Remove the legend
                },
                annotation: {
                    annotations: {
                        currentTimeLine: {
                            type: 'line',
                            xMin: now,
                            xMax: now,
                            borderColor: 'red',
                            borderWidth: 2,
                            label: {
                                content: 'Now',
                                enabled: true,
                                position: 'start',
                                backgroundColor: 'rgba(255, 99, 132, 0.8)'
                            }
                        }
                    }
                }
            }
        }
    });
}

fetchTideData().then(plotTideData);