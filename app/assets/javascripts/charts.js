(function (global) {
  var $ = global.jQuery

  var monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']

  var getMonthList = function (dates) {
    var resultList = []
    var startDate = new Date(dates.start.getTime())

    while (startDate <= dates.end) {
      var stringDate = monthNames[startDate.getMonth()]
      resultList.push(stringDate)
      startDate.setMonth(startDate.getMonth() + 1)
    }

    return resultList
  }

  var getDateRange = function () {
    var s = $('#start_date')
    var e = $('#end_date')
    if (s.size() === 0 || e.size() === 0) { return {valid: false} }
    return {
      start: new Date(s.text()),
      end: new Date(e.text()),
      valid: true
    }
  }

  var chartSetup = function () {
    var dates = getDateRange()
    if (!dates.valid) { return }

    var timeString = monthNames[dates.start.getMonth()] + ' ' + dates.start.getFullYear() +
      ' to ' + monthNames[dates.end.getMonth()] + ' ' + dates.end.getFullYear()

    $('.chart').each(function () {
      var targetId = '#' + $(this).attr('id')

      var points = $(this).data('metrics').split(',')
      points = points.map(function (p) { return parseInt(p, 10) })

      var setAxisTransactions = {
        x: {
          type: 'category',
          categories: getMonthList(dates)
        },
        y: {
          min: 0,
          max: points.reduce(function (a, b) { return Math.max(a, b) }),
          padding: { top: 0, bottom: 0 },
          tick: { count: 5 }
        }
      }

      c3.generate({
        bindto: targetId,
        data: {
          columns: [
            [timeString].concat(points)
          ]
        },
        axis: setAxisTransactions,
        size: { height: 250 },
        color: { pattern: ['#005EA5'] },
        transition: { duration: null },
        padding: { top: 10, bottom: 20 },
        point: { show: false }
      })
    })
  }

  $(document).ready(function () {
    chartSetup()
  })
})(window)
