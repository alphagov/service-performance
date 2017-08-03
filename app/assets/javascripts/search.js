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

    var _search = function (fn) {
      var query = $.trim($searchInput.val().toLowerCase())
      fn(query)
    }

    var _setListenersOnInput = function (fn) {
      $searchInput.on('keyup search', function () {
        _search(fn)
      })
    }

    var init = function (fn) {
      $searchFilter = $('[data-behaviour="m-search-filter"]').first()
      $searchInput = $searchFilter.find('input[type="search"]')

      $searchFilter.removeClass('hidden')
      _setListenersOnInput(fn)
    }

    return {
      init: init
    }
  })()

  global.SearchResultsContainer = SearchResultsContainer
  global.SearchFilter = SearchFilter
})(window)
