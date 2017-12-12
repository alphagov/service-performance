(function (global) {
  var $ = global.jQuery

  var month_names = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

  var get_month_list = function(dates) {
    var resultList = [];
    var start_date = new Date(dates.start.getTime());

    while (start_date <= dates.end)
    {
        var stringDate = month_names[start_date.getMonth()];
        resultList.push(stringDate);
        start_date.setMonth(start_date.getMonth() + 1);
    }

    return resultList;
  }

  var get_date_range = function() {
    var s = $('#start_date');
    var e = $('#end_date');
    if (s.size() == 0 || e.size() == 0) { return {valid: false}; }
    return {
      start: new Date(s.text()),
      end: new Date(e.text()),
      valid: true
    }
  }

  var chart_setup = function () {
    var dates = get_date_range();
    if (!dates.valid) { return; }

    var timeString = month_names[dates.start.getMonth()] + " " + dates.start.getFullYear() +
      " to " + month_names[dates.end.getMonth()] + " " + dates.end.getFullYear();

    $('.chart').each(function(){
      var target_id = "#" + $(this).attr('id')

      var points = $(this).data("metrics").split(",");
      points = points.map(function(p) { return parseInt(p, 10) });

      var setAxisTransactions = {
        x: {
          type: 'category',
          categories: get_month_list(dates)
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
        color: { pattern: ['#005EA5'] },
        transition: { duration: null },
        padding: { top: 10, bottom: 20 },
        point: { show: false }
      });
    });
  }

  $(document).ready(function () {
    chart_setup()
  })
})(window)

