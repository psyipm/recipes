tpl = '
<span>
  <span class="rating" title="Рейтинг">
    <span class="icon icon-heart"></span>
    {{recipe.rating || 0}}
  </span>

  <span class="user-rating right" title="Ваша оценка">
    <button class="btn btn-default btn-noborder btn-noborder-success">
      <span id="recipe-{{recipe.id}}-rating" class="icon icon-heart"></span>
    </button>
  </span>
</span>
'
angular.module('receta').directive('recipeRating', ['Rating', '$timeout', (Rating, $timeout)->
  restrict: "E"
  template: tpl
  scope: {
    recipe: "="
  }
  link: (scope, element)->
    $timeout((-> scope.setUserRate(Rating.check scope.recipe.id)), 1)

    element.bind('click', ()->
      scope.changeRating()
      scope.$apply()
    )

  controller: ['$scope', 'Rating', ($scope, Rating)->
    selector = "#recipe-#{$scope.recipe.id}-rating"
    $scope.setUserRate = (rate)->
      if parseInt(rate) > 0
        $(selector)
          .removeClass("icon-heart-broken sux")
          .addClass("rated rulez icon-heart")
        return
      if parseInt(rate) < 0
        $(selector)
          .removeClass("icon-heart rulez")
          .addClass("rated sux icon-heart-broken")
        return

    $scope.changeRating = ()->
      oldrate = Rating.check $scope.recipe.id
      rate = if oldrate == 0 then 1 else oldrate*-1

      if Rating.rate $scope.recipe.id, rate
        $scope.setUserRate rate
        $scope.recipe.rating += rate
  ]
])