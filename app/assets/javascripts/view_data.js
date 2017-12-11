// = require jquery
// = require metrics_filter_panel
// = require collapsed_metric_group
// = require metric_guidance
// = require search
// = require d3.min
// = require c3.min
// = require charts

;(function (global) {
  /* Both of these are in the `search.js` file */

  var $ = global.jQuery

  $(document).ready(function () {
    global.SearchResultsContainer.init()
    global.SearchFilter.init(
      global.SearchResultsContainer.filter,
      global.SearchResultsContainer.getResultsLength()
    )
  })
})(window)
