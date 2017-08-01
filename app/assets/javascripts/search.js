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
      var matches = 0

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
          matches++
        } else {
          $(this).addClass('hidden')
        }
      })

      return matches
    }

    return {
      init: init,
      filter: filter,
      getResultsLength: function () { return $results.length }
    }
  })()

  var SearchFilter = (function () {
    var $searchFilter
    var $searchInput
    var $searchCounter

    var _search = function (searchFn, resultsLength) {
      var query = $.trim($searchInput.val().toLowerCase())
      var matches = searchFn(query)
      _updateCounter(matches, resultsLength, query)
    }

    var _updateCounter = function (matches, total, query) {
      var searchCounterHTML = ''

      // show the counter if the search box is not empty
      query
        ? $searchCounter.removeClass('visuallyhidden')
        : $searchCounter.addClass('visuallyhidden')

      if (matches === total) {
        searchCounterHTML = '<strong>' + matches + '</strong> total results'
      } else if (matches === 1) {
        searchCounterHTML = '<strong>' + matches + '</strong> result found'
      } else if (matches === 0) {
        searchCounterHTML = 'No results'
      } else {
        searchCounterHTML = '<strong>' + matches + '</strong> results found'
      }

      $searchCounter.html(searchCounterHTML)
    }

    var _setListenersOnInput = function (fn, resultsLength) {
      $searchInput.on('keyup search', function () {
        _search(fn, resultsLength)
      })
    }

    var init = function (searchFn, resultsLength) {
      $searchFilter = $('[data-behaviour="m-search-filter"]').first()
      $searchInput = $searchFilter.find('input[type="search"]')
      $searchCounter = $searchFilter.find('[data-behaviour="a-search-counter"]')

      $searchFilter.removeClass('hidden')
      _setListenersOnInput(searchFn, resultsLength)
      _updateCounter(resultsLength, resultsLength)
    }

    return {
      init: init
    }
  })()

  global.SearchResultsContainer = SearchResultsContainer
  global.SearchFilter = SearchFilter
})(window)
