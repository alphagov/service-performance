;(function (global) {
  'use strict'

  var $ = global.jQuery

  var SearchResultsContainer = (function () {
    var $searchResultContainer
    var $results

    var _setSearchDataAttributesOnResults = function () {
      /*
        Add the lowercased search terms to a 'data-search' attribute
        for each possible search result
       */
      $results.each(function () {
        var searchTerms = $(this).find('h2').text()
        $(this).attr('data-search', searchTerms.toLowerCase())
      })
    }

    var init = function () {
      $searchResultContainer = $('[data-behaviour="o-metric-groups"]').first()
      $results = $searchResultContainer.find('[data-behaviour^="m-metric-group"]')

      _setSearchDataAttributesOnResults()
    }

    var filter = function (query) {
      /*
        Hide search results unless the query substring matches the title
       */

      // if query is empty, remove all hidden classes and return length of results
      if (!query) {
        $results.removeClass('hidden')
        return $results.length
      }

      $results.each(function () {
        var searchTerms = $(this).attr('data-search')
        var isMatch = searchTerms.indexOf(query) !== -1

        if (isMatch) {
          $(this).removeClass('hidden')
        } else {
          $(this).addClass('hidden')
        }
      })
    }

    return {
      init: init,
      filter: filter
    }
  })()

  var SearchFilter = (function () {
    var $searchFilter
    var $searchInput
    var $searchButton

    var _search = function (fn) {
      var query = $searchInput.val().toLowerCase().trim()
      fn(query)
    }

    var _setKeyListenerOnInput = function (fn) {
      $searchInput.on('keyup', function () {
        _search(fn)
      })
    }

    var _setClickListenerOnButton = function (fn) {
      $searchButton.on('click', function (e) {
        _search(fn)
        e.preventDefault()
      })
    }

    var init = function (fn) {
      $searchFilter = $('[data-behaviour="m-search-filter"]').first()
      $searchInput = $searchFilter.find('input[type="search"]')
      $searchButton = $searchFilter.find('input[type="button"]')

      $searchFilter.removeClass('hidden')
      _setKeyListenerOnInput(fn)
      _setClickListenerOnButton(fn)
    }

    return {
      init: init
    }
  })()

  global.SearchResultsContainer = SearchResultsContainer
  global.SearchFilter = SearchFilter
})(window)
