class ToggleText
  toggle: ($event) ->
    target = $event.target
    collapsed = $(target).hasClass("collapsed")

    if(collapsed)
      $(target).removeClass("collapsed")
      return
    else
      $(target).addClass("collapsed")
      return

angular.module('receta').directive('recipe', ()->
  return {
    restrict: "E",
    scope: {
      recipe: '=',
      tags: '=',
      components: '=',
      photos: '=',
      view: '='
    },
    templateUrl: 'recipes/recipe.html',
    controller: ['$scope', ($scope)->
      t = new ToggleText()
      $scope.toggle = ($event)->
        t.toggle($event)
    ]
  }
)