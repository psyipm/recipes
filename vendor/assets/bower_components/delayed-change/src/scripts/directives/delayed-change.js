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