angular.module('receta').directive('alerts', ()->
	return {
		restrict: "E",
		scope: '=',
		template: '<alert ng-repeat="alert in alerts" type="{{alert.type}}" close="closeAlert($index)">{{alert.msg}}</alert>'
		controller: ['$scope', ($scope)->
			$scope.closeAlert = (index)->
				$scope.alerts.splice index, 1
		]
	}
)