(function($, root) {
  "use strict";
  root.GOVUK = root.GOVUK || {};
  GOVUK.Modules = GOVUK.Modules || {};

  GOVUK.modules = {
    find: function(container) {
      var modules,
          moduleSelector = '[data-module]',
          container = container || $('body');

      modules = container.find(moduleSelector);

      // Container could be a module too
      if (container.is(moduleSelector)) {
        modules = modules.add(container);
      }

      return modules;
    },

    start: function(container) {
      var modules = this.find(container);

      for (var i = 0, l = modules.length; i < l; i++) {
        var module,
            element = $(modules[i]),
            type = camelCaseAndCapitalise(element.data('module')),
            started = element.data('module-started');


        if (typeof GOVUK.Modules[type] === "function" && !started) {
          module = new GOVUK.Modules[type]();
          module.start(element);
          element.data('module-started', true);
        }
      }

      // eg selectable-table to SelectableTable
      function camelCaseAndCapitalise(string) {
        return capitaliseFirstLetter(camelCase(string));
      }

      // http://stackoverflow.com/questions/6660977/convert-hyphens-to-camel-case-camelcase
      function camelCase(string) {
        return string.replace(/-([a-z])/g, function (g) {
          return g[1].toUpperCase();
        });
      }

      // http://stackoverflow.com/questions/1026069/capitalize-the-first-letter-of-string-in-javascript
      function capitaliseFirstLetter(string) {
        return string.charAt(0).toUpperCase() + string.slice(1);
      }
    }
  }
})(jQuery, window);
(function($, Modules) {
  'use strict';

  Modules.Navigation = function () {
    var $html = $('html');

    var $navToggle;
    var $nav;

    this.start = function ($element) {
      $navToggle = $('.js-nav-toggle', $element);
      $nav = $('.js-nav', $element);

      updateAriaAttributes();

      $navToggle.on('click', toggleNavigation);
      $(window).on('resize', updateAriaAttributes);
    }

    function updateAriaAttributes() {
      var navIsVisible = $nav.is(':visible');

      $navToggle.attr('aria-expanded', navIsVisible ? 'true' : 'false');
      $nav.attr('aria-hidden', navIsVisible ? 'false' : 'true');
    }

    function toggleNavigation() {
      var navIsVisible = !$html.hasClass('nav-open');

      $html.toggleClass('nav-open', navIsVisible);
      updateAriaAttributes();
    }
  };
})(jQuery, window.GOVUK.Modules);



$(document).ready(function() {
  GOVUK.modules.start();
});
