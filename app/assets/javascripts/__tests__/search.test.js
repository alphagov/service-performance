'use strict'

// set the window.jQuery variable that the file expects
window.jQuery = require('../../../../vendor/assets/javascripts/product-page-template/vendor/jquery.js')

describe('The search filter', function () {
  var $ = window.jQuery
  var $content

  beforeEach(function () {
    $content = $(
      '<div class="m-search-filter hidden" id="search-filter">' +
        '<label for="search-departments" class="visuallyhidden">Find department</label>' +
        '<input type="search" id="search-departments" class="a-search-input" placeholder="Find department">' +
        '<input class="a-search-button" type="button" value="Search">' +
      '</div>')

    // Add to page
    $(document.body).append($content)
  })

  afterEach(function () {
    $content.remove()
  })

  it('should lose the hidden class when the page loads', function () {
    require('../search')
    window.SearchFilter.init()

    // Use jquery to emulate a click on our button
    var $searchFilter = $('#search-filter')
    expect($searchFilter.hasClass('hidden')).toEqual(false)
  })
})
