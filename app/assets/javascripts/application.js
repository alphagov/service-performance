// = require jquery
// = require collapsed_metric_group
// = require metrics_filter_panel
// = require search

;(function (global) {
  /* Both of these are in the `search.js` file */
  global.SearchResultsContainer.init()
  global.SearchFilter.init(global.SearchResultsContainer.filter)
})(window)
