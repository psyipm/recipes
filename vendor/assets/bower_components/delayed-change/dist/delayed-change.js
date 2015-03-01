/**
 * @ngdoc overview
 * @name delayed-change
 * @description
 *
 * Serves a similar functionality as @ngChange, but groups calls
 * together if they are done quickly after one another.
 *
 * Useful for avoiding intensive function calls done often
 * (e.g. fast typing) into one call.
 */
angular.module('delayed-change', []);

/**
 * @ngdoc directive
 * @name delayed-change:delayedChange
 * @description
 * Directive for delayed change functionality
 */
angular.module('delayed-change')
  .directive('delayedChange', ['$timeout', '$delayed', function ($timeout, $delayed) {
    return {
      require: 'ngModel',
      scope: {
        delayedOptions: '=',
        delayedChange: '@',
        delay: '=delayedCustom'
      },
      link: function (scope, element, attr, ctrl) {
        var invoke = function () {
          scope.$parent.$eval(scope.delayedChange);
        };

        var opts = scope.delayedOptions,
          delay = scope.delay || $delayed(invoke, opts);

        //Invoke delay function when view value changes
        ctrl.$viewChangeListeners.push(function () {
          delay.invoke();
        });
      }
    };
  }]);
/**
 * @ngdoc service
 * @name delayed-change:$delayed
 * @description
 * Service to delay the calling of a function. Implements actual
 * functionality for @delayedChange directive.
 */
angular.module('delayed-change')
  .service('$delayed', ['$timeout', '$q', function ($timeout, $q) {
    var Delayed = function (func, opts) {
      var self = this;

      self.$opts = angular.extend({
        delay: 300,
        invoked: null,
        start: null,
        end: null
      }, opts);

      self.$promise = null;
      self.loading = false;
      self.$func = func;

      /**
       * Invokes the delay function timer. This will eventually call the given delay
       * function. If the delay timer was previously invoked but has not been completed,
       * it will reset the timer.
       *
       * @return {promise}
       */
      self.invoke = function () {
        self.cancel();
        self.$promise = $timeout(self.$invoke, self.$opts.delay);

        if (angular.isFunction(self.$opts.invoked)) self.$opts.invoked();
        self.loading = true;

        return self.$promise;
      };

      /**
       * Actual function invoked when timer completes
       */
      self.$invoke = function () {
        if (angular.isFunction(self.$opts.start)) self.$opts.start();
        var promise = self.$func();

        //Invoke end function after everything is complete
        $q.when(promise).then(function () {
          if (angular.isFunction(self.$opts.end)) self.$opts.end();
          self.loading = false;
        });
      };

      /**
       * Cancels the pending function call, if any.
       */
      self.cancel = function () {
        $timeout.cancel(self.$promise);
        self.$promise = null;
        self.loading = false;
      };
    };

    return function (func, opts) {
      return new Delayed(func, opts);
    };
  }]);