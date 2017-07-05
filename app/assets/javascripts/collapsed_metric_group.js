(function() {

  $.fn.collapsedMetricGroup = function() {
    $(this).addClass('m-metric-group__collapsed');
  }

  $(document).ready(function() {
    $('[data-behaviour="m-metric-group__collapsed"]').collapsedMetricGroup();
  });

})()
