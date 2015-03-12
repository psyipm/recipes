class ToggleText
  toggle: ($event) ->
    target = if $($event.target).hasClass('recipe-text') then $event.target else $($event.target).parent()
    btn = $(target).find(".read-all")
    text = $(target).find(".recipe-descr")
    collapsed = $(btn).hasClass("collapsed")

    if(collapsed)
      $(btn)
        .removeClass("collapsed")
        .text("Свернуть описание ▴")
      $(text).removeClass("short")
      return
    else
      $(btn)
        .addClass("collapsed")
        .text("Показать полностью ▾")
      $(text).addClass("short")
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