// = require jquery
// = require metrics_filter_panel
// = require collapsed_metric_group
// = require search
// = require d3
// = require c3

/*global d3*/

;(function (global) {
  /* Both of these are in the `search.js` file */

  var $ = global.jQuery

  $(document).ready(function () {
    global.SearchResultsContainer.init()
    global.SearchFilter.init(
      global.SearchResultsContainer.filter,
      global.SearchResultsContainer.getResultsLength()
    )

    $('input[type=radio]').click(function () {
      if ($('#range_custom').is(':checked')) {
        $('#range').toggle()
      } else {
        $('#range').hide()
      }
    })
  })

  $(document).ready(function () {
    var $ = global.jQuery

    if ($('.chart').size() === 0) return

    var cSize = { height: 250 }
    var cColour = { pattern: ['#005EA5', '#005EA5'] }
    var cTransition = { duration: null }
    var cPadding = { top: 10, bottom: 20 }
    var cPoint = { show: false }
    var cRegions = {}

    $('.chart').each(function (idx, obj) {
      var currentLabel = $(obj).data('current-range-label')
      var previousLabel = $(obj).data('previous-range-label')
      cRegions[previousLabel] = [ { 'style': 'dashed' } ]

      var currentData = $(obj).data('current-data')
      var previousData = $(obj).data('previous-data')
      var maxValue = $(obj).data('max-value')

      var months = $(obj).data('months')

      var setAxisTransactions = {
        x: {
          type: 'category',
          categories: months
        },
        y: {
          min: 0,
          max: maxValue,
          padding: { top: 0, bottom: 0 },
          tick: { format: function (x) { return d3.format(',.0f')(x) } }
        }
      }

      // Insert the label at the start of the data list.
      currentData.unshift(currentLabel)
      previousData.unshift(previousLabel)

      /* eslint-disable */
      c3.generate({
        bindto: '#' + $(obj).attr('id'),
        data: {
          columns: [
            previousData,
            currentData
          ],
          regions: cRegions
        },
        tooltip: {
          format: {
              value: function(value) {
                  return d3.format(',.0f')(value) + '&nbsp;&nbsp;&nbsp;'
              }
          }
        },
        axis: setAxisTransactions, size: cSize, color: cColour, transition: cTransition, padding: cPadding, point: cPoint
      });
      /* eslint-enable */
    })
  })
})(window)
