// = require jquery
// = require metrics_filter_panel
// = require collapsed_metric_group
// = require metric_guidance
// = require search

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
})(window)
