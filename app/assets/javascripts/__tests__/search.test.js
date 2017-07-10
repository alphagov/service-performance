'use strict'

// set the window.jQuery variable that the file expects
window.jQuery = require('../../../../vendor/assets/javascripts/product-page-template/vendor/jquery.js')
// will set SearchResultsContainer and SearchFilter on the window object
require('../search')

describe('On the search page', function () {
  var $ = window.jQuery
  var searchFilterHTML =
    '<div class="m-search-filter hidden" id="search-filter">' +
      '<label for="search-departments" class="visuallyhidden">Find department</label>' +
      '<input type="search" id="search-departments" class="a-search-input" placeholder="Find department">' +
      '<input class="a-search-button" type="button" value="Search">' +
    '</div>'

  var SearchResultsHTML =
    '<div class="metrics-groups grid-row" id="search-results">' +
      '<ul>' +
        '<li class="metric-group">' +
          '<h2 class="bold-medium"><a>HM Revenue &amp; Customs</a></h2>' +
        '</li>' +
        '<li class="metric-group">' +
          '<h2 class="bold-medium"><a>Department For Transport</a></h2>' +
        '</li>' +
      '</ul>' +
    '</div>'

  var $searchFilter
  var $searchInput
  var $results

  describe('the search page filter', function () {
    beforeEach(function () {
      // Add HTML to page
      $(document.body).append($(searchFilterHTML))
      $searchFilter = $('#search-filter')
    })

    afterEach(function () {
      // Drop everything from the page
      $(document.body).empty()
    })

    it('should lose the hidden class when the page loads', function () {
      window.SearchFilter.init()

      expect($searchFilter.hasClass('hidden')).toEqual(false)
    })

    describe('when there are also search results', function () {
      beforeEach(function () {
        // Add search results HTML to page (it already has the search filter)
        $(document.body).append($(SearchResultsHTML))
        $searchInput = $searchFilter.find('input[type="search"]')
        $results = $('.metric-group')

        window.SearchResultsContainer.init()
        window.SearchFilter.init(window.SearchResultsContainer.filter)
      })

      afterEach(function () {
        // Drop everything from the page
        $(document.body).empty()
      })

      it('should filter the search results when clicked', function () {
        $searchInput.val('revenue')
        $searchFilter.find('input[type="button"]').trigger('click')

        expect($results.eq(0).hasClass('hidden')).toEqual(false)
        expect($results.eq(1).hasClass('hidden')).toEqual(true)
      })

      it('should filter the search results on keyup', function () {
        $searchInput.val('revenue').trigger('keyup')

        expect($results.eq(0).hasClass('hidden')).toEqual(false)
        expect($results.eq(1).hasClass('hidden')).toEqual(true)
      })

      it('should filter the search results ignoring spaces', function () {
        $searchInput.val('     revenue    ').trigger('keyup')

        expect($results.eq(0).hasClass('hidden')).toEqual(false)
        expect($results.eq(1).hasClass('hidden')).toEqual(true)
      })

      it('should filter the search results ignoring capital letters', function () {
        $searchInput.val('ReVenUe').trigger('keyup')

        expect($results.eq(0).hasClass('hidden')).toEqual(false)
        expect($results.eq(1).hasClass('hidden')).toEqual(true)
      })
    })
  })

  describe('The search results', function () {
    beforeEach(function () {
      // Add to page
      $(document.body).append($(SearchResultsHTML))

      window.SearchResultsContainer.init()
      $results = $('.metric-group')
    })

    afterEach(function () {
      // Drop everything from the page
      $(document.body).empty()
    })

    it('should have data-search attributes with search terms when the page loads', function () {
      expect($results.eq(0).attr('data-search')).toEqual('hm revenue & customs')
      expect($results.eq(1).attr('data-search')).toEqual('department for transport')
    })

    it('should be filtered when a matching substring query is given', function () {
      window.SearchResultsContainer.filter('revenue')

      expect($results.eq(0).hasClass('hidden')).toEqual(false)
      expect($results.eq(1).hasClass('hidden')).toEqual(true)
    })

    it('should be filtered when a exact matching query is given', function () {
      window.SearchResultsContainer.filter('hm revenue & customs')

      expect($results.eq(0).hasClass('hidden')).toEqual(false)
      expect($results.eq(1).hasClass('hidden')).toEqual(true)
    })

    it('should be revealed when an empty query is given', function () {
      window.SearchResultsContainer.filter('')

      expect($results.eq(0).hasClass('hidden')).toEqual(false)
      expect($results.eq(1).hasClass('hidden')).toEqual(false)
    })

    function _assertBothResultsAreHidden (query) {
      window.SearchResultsContainer.filter(query)

      expect($results.eq(0).hasClass('hidden')).toEqual(true)
      expect($results.eq(1).hasClass('hidden')).toEqual(true)
    }

    it('should be hidden when a non-matching query is given', function () {
      _assertBothResultsAreHidden('zzz')
    })

    it('should be hidden when a misspelt word is given', function () {
      _assertBothResultsAreHidden('tramsport')
    })

    it('should be hidden when words are out of order', function () {
      _assertBothResultsAreHidden('transport for department')
    })

    it('should be hidden when punctuation is spelled out', function () {
      _assertBothResultsAreHidden('hm revenue and customs')
    })
  })
})
