class ToggleText
  toggle: ($event) ->
    target = $event.target
    console.log $event
    collapsed = $(target).hasClass("collapsed")
    $arrow = $(target).parent().parent().find("a.toggle-text")

    if(collapsed)
      $(target).removeClass("collapsed")
      $arrow.text("▴")
      return
    else
      $(target).addClass("collapsed")
      $arrow.text("▾")
      return

angular.module('receta').directive('recipe', ()->
  return {
    restrict: "E",
    scope: {
      recipe: '=',
      tags: '=',
      components: '=',
      photos: '='
    },
    templateUrl: 'recipes/recipe.html',
    controller: ['$scope', ($scope)->
      t = new ToggleText()
      $scope.toggle = ($event)->
        t.toggle($event)
    ]
  }
)