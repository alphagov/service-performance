//= require jquery

$(document).ready(function() {
  $('.metric-guidance').hide();
  $('.show-guidance button').click(function() {
    $(this).closest('.filter-cards li').find('.metric-guidance').toggle();
    $(this).closest('.filter-cards li').find('.metric-name').toggleClass('bold');
    $(this).find('span').toggle();
  });
});
