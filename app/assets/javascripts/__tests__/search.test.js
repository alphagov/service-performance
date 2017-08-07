'use strict'

/* global JQUERY_PATH */

// set the window.jQuery variable that the file expects
window.jQuery = require(JQUERY_PATH)
// will set SearchResultsContainer and SearchFilter on the window object
require('../search')

describe('On the search page', function () {
  var $ = window.jQuery
  var searchFilterHTML =
    '<div class="m-search-filter hidden" data-behaviour="m-search-filter">' +
      '<label for="search-metrics">Find department</label>' +
      '<input type="search" id="search-metrics" class="a-search-input" placeholder="Example: environment">' +
    '</div>'

  var SearchResultsHTML =
    '<div class="o-metric-groups" data-behaviour="o-metric-groups">' +
      '<ul>' +
        '<li class="m-metric-group" data-behaviour="m-metric-group">' +
          '<h2 class="bold-medium"><a>HM Revenue &amp; Customs</a></h2>' +
        '</li>' +
        '<li class="m-metric-group" data-behaviour="m-metric-group">' +
          '<h2 class="bold-medium"><a>Department For Transport</a></h2>' +
        '</li>' +
      '</ul>' +
    '</div>'

  var $searchFilter
  var $searchInput
  var $results

  function _assertAllResults (opts) {
    return function (query) {
      opts.filterFn(query)

      expect($results.length).toBeGreaterThan(0)
      $results.each(function () {
        expect($(this).hasClass('hidden')).toEqual(!opts.isVisible)
      })
    }
  }

  function _assertOneResult (opts) {
    return function (query) {
      opts.filterFn(query)

      expect($results.length).toBeGreaterThan(0)

      var selector = opts.isVisible
        ? ':not(.hidden)'
        : '.hidden'
      var $result = $results.filter(selector)
      expect($result.length).toEqual(1)
    }
  }

  describe('the search page filter', function () {
    beforeEach(function () {
      // Add HTML to page
      $(document.body).append($(searchFilterHTML))
      $searchFilter = $('[data-behaviour="m-search-filter"]')
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
        $results = $('[data-behaviour^="m-metric-group"]')

        window.SearchResultsContainer.init()
        window.SearchFilter.init(window.SearchResultsContainer.filter)
      })

      afterEach(function () {
        // Drop everything from the page
        $(document.body).empty()
      })

      it('should filter the search results on keyup', function () {
        $searchInput.val('revenue').trigger('keyup')

        expect($results.eq(0).hasClass('hidden')).toEqual(false)
        expect($results.eq(1).hasClass('hidden')).toEqual(true)
      })

      it('should filter the search results on search', function () {
        $searchInput.val('revenue').trigger('search')

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
      $results = $('[data-behaviour^="m-metric-group"]')
    })

    afterEach(function () {
      // Drop everything from the page
      $(document.body).empty()
    })

    function _filterResults (query) {
      expect(window.SearchResultsContainer).not.toBe(undefined)
      window.SearchResultsContainer.filter(query)
    }

    var assertAllResultsAreHidden = _assertAllResults(
      {filterFn: _filterResults, isVisible: false})

    var assertAllResultsAreVisible = _assertAllResults(
      {filterFn: _filterResults, isVisible: true})

    var assertOneResultIsVisible = _assertOneResult(
      {filterFn: _filterResults, isVisible: false})

    it('should have data-search attributes with search terms when the page loads', function () {
      expect($results.eq(0).attr('data-search')).toEqual('hm revenue & customs')
      expect($results.eq(1).attr('data-search')).toEqual('department for transport')
    })

    it('should be filtered when a matching substring query is given', function () {
      assertOneResultIsVisible('revenue')
      expect($results.filter(':contains("HM Revenue")').hasClass('hidden')).toEqual(false)
    })

    it('should be filtered when a exact matching query is given', function () {
      assertOneResultIsVisible('hm revenue & customs')
      expect($results.filter(':contains("HM Revenue")').hasClass('hidden')).toEqual(false)
    })

    it('should be revealed when an empty query is given', function () {
      assertAllResultsAreVisible('')
    })

    it('should be hidden when a non-matching query is given', function () {
      assertAllResultsAreHidden('zzz')
    })

    it('should be hidden when a misspelt word is given', function () {
      assertAllResultsAreHidden('tramsport')
    })

    it('should be hidden when words are out of order', function () {
      assertAllResultsAreHidden('transport for department')
    })

    it('should be hidden when punctuation is spelled out', function () {
      assertAllResultsAreHidden('hm revenue and customs')
    })
  })
})
