(function() {

  $.fn.metricsFilterPanel = function() {
    this.find('.a-apply-button').hide();

    var sortFilter = this.find('.m-sort-filter');
    sortFilter.on('change', 'input, select', function() {
      $(this).parents('form').submit();
    });

    var sortOrderSelector = this.find('.m-sort-order');
    sortOrderSelector.find('input').hide();
    sortOrderSelector.find('input:checked').parents('label').addClass('checked');
  }

  $(document).ready(function() {
    $('[data-behaviour="o-filter-panel"]').metricsFilterPanel();
  });

})()
