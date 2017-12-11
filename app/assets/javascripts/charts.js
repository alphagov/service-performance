$(document).ready(function () {

  var s = new Date("2016-09-01")
  var e = new Date("2017-08-31")
  var monthNameList = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

  var setColour = { pattern: ['#005EA5'] }
  var timeString = monthNameList[s.getMonth()] + " " + s.getFullYear() + " to " +
    monthNameList[e.getMonth()] + " " + e.getFullYear();

  var get_month_list = function(start_date, end_date) {
    var resultList = [];

    while (start_date <= end_date)
    {
        var stringDate = monthNameList[start_date.getMonth()];
        resultList.push(stringDate);
        start_date.setMonth(start_date.getMonth() + 1);
    }

    return resultList;
  }
  var months = get_month_list(s, e)

  $('.chart').each(function(){
    var target_id = "#" + $(this).attr('id')
    var points = $(this).data("metrics").split(",");
    points = points.map(function(p) { return parseInt(p, 10) });

    var setAxisTransactions = {
      x: {
        type: 'category',
        categories: months
      },
      y: {
        min: 0,
        max: points.reduce(function(a, b) {return Math.max(a, b);}),
        padding: {top:0, bottom:0},
        tick: { count: 5 }
      }
    }

    c3.generate({
      bindto: target_id,
      data: {
        columns: [
          [timeString].concat(points)
        ],
      },
      axis: setAxisTransactions,
      size: { height: 250 },
      color: setColour,
      transition: { duration: null },
      padding: { top: 10, bottom: 20 },
      point: { show: false }
    });
  });
});
