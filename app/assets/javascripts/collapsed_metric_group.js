(function() {

  // Unescapes HTML entities.
  //
  // It's important that this function uses a `textarea` element to avoid
  // introducing XSS vulnerabilities if this function is ever used with
  // untrusted user input.
  //
  // See: https://stackoverflow.com/a/1395954
  var decodeEntities = function(encodedString) {
      var textArea = document.createElement('textarea');
      textArea.innerHTML = encodedString;
      return textArea.value;
  }

  $.fn.collapsedMetricGroup = function() {
    // Determine which metric item has been sorted on. If we can't determine
    // it, then abort.
    var selectedMetricItem = $('[data-behaviour="o-filter-panel"] option:selected').val();
    if(!selectedMetricItem) {
      return;
    }

    $(this).each(function(idx, element) {
      // Find the description for the selected metric item. If none is found
      // then, continue with the next metric group.
      var metricItem = $(element).find('[data-metric-item-identifier="' + selectedMetricItem + '"]');
      var metricItemDescription = metricItem.data('metric-item-description');
      if(!metricItemDescription) {
        return;
      }

      // Find the "expanded" container, this has the full metric group
      // information. Build the collapsed container with it's elements.
      var expandedContainer = $(element).find('[data-metric-group-expanded]');

      var collapsedHeaderContainer = $("<div />", { class: 'm-metric-group-header' });
      var metricItemDescriptionContainer = $('<div />', { class: 'm-metric-item-description' });
      var openLinkContainer = $("<div />", { class: 'm-metric-group-open-toggle' });
      var collapsedContainer = $('<div data-metric-group-collapsed>')
                                 .addClass('m-metric-group__collapsed')
                                 .append(collapsedHeaderContainer, metricItemDescriptionContainer, openLinkContainer);

      // Populate the collapsed header container, with the header from the
      // expanded variant.
      var heading = $(element).find('.m-metric-group-header h2').clone();
      collapsedHeaderContainer.append(heading);

      // Populate the metric item description container, using HTML unescaped
      // content from the data attribute.
      metricItemDescriptionContainer.html(decodeEntities(metricItemDescription));
      collapsedContainer.append(metricItemDescriptionContainer);

      // Create an open link, and give it a click behaviour to show the
      // expanded variant.
      var openLink = $('<a href="#">Open</a>');
      openLink.on('click', function(e) {
        e.preventDefault();

        collapsedContainer.hide();
        expandedContainer.show();
      });
      openLinkContainer.append(openLink);
      collapsedContainer.append(openLinkContainer);

      // Add the collapsed container to the metric group, and hide the
      // expanded container.
      $(element).append(collapsedContainer);
      expandedContainer.hide();
    });
  }

  $(document).ready(function() {
    $('[data-behaviour="m-metric-group__collapsed"]').collapsedMetricGroup();
  });

})()
