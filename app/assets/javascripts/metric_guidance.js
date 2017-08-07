(function (global) {
  var $ = window.jQuery

  $.fn.metricGuidanceToggle = function () {
    $(this).on('click', function (e) {
      e.preventDefault()

      var element = $(this)
      var container = element.parents('[data-metric-item-guidance]')
      var data = container.data()
      var guidance = data['metricItemGuidance']

      var metricGuidance = container.find('[data-metric-guidance]')
      if (metricGuidance.length === 0) {
        var descriptionElement = $('<p />', {'class': 'a-metric-guidance', 'data-metric-guidance': 'data-metric-guidance'})
        descriptionElement.text(guidance)

        container.append(descriptionElement)
        metricGuidance = descriptionElement
      }

      var collapsed = element.data('metric-guidance-collapsed')

      element.data('metric-guidance-collapsed', !collapsed)
      $(metricGuidance).toggle(!collapsed)
      $(element).toggleClass('a-metric-guidance-expand', collapsed)
      $(element).toggleClass('a-metric-guidance-collapse', !collapsed)
    })
  }

  $(document).ready(function () {
    $('[data-behaviour="a-metric-guidance-toggle"]').metricGuidanceToggle()
  })
})(window)
