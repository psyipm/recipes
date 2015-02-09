angular.module('receta').controller("UserSessionsController", ['$scope', '$location',
  ($scope,$location)->
    $scope.alerts = []

    $scope.$on('auth:login-error', (ev, reason)->
      $scope.alerts.push {type: 'danger', msg: reason.errors[0]}
    )

    $scope.$on('auth:login-success', ()->
      $location.path('/')
    )
])