(function() {

  $.fn.collapsedMetricGroup = function() {
    $(this).each(function(idx, element) {
      $(element).addClass('m-metric-group__collapsed');

      var heading = $(element).find('.m-metric-group-header h2').clone();

      var expandedContainer = $(element).find('[data-metric-group-expanded]');
      var collapsedContainer = $('<div data-metric-group-collapsed>');

      expandedContainer.hide();
      collapsedContainer.append(heading);

      $(element).append(collapsedContainer);

      var openLink = $('<a href="#">Open</a>');
      openLink.on('click', function(e) {
        e.preventDefault();

        collapsedContainer.hide();
        expandedContainer.show();
      });
      collapsedContainer.append(openLink);
    });
  }

  $(document).ready(function() {
    $('[data-behaviour="m-metric-group__collapsed"]').collapsedMetricGroup();
  });

})()
