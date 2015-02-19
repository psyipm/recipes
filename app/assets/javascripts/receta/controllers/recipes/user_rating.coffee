angular.module('receta').controller('RecipeUserRatingController', ['$scope', 'Rating', ($scope, Rating)->
  selector = "#recipe-#{$scope.recipe.id}-rating"
  $scope.setUserRate = (rate)->
    if parseInt(rate) > 0
      $(selector)
        .removeClass("icon-heart-broken sux")
        .addClass("rated rulez icon-heart")
        .attr("title", "Мне нравится")
      return
    if parseInt(rate) < 0
      $(selector)
        .removeClass("icon-heart rulez")
        .addClass("rated sux icon-heart-broken")
        .attr("title", "Мне не нравится")
      return

  $scope.changeRating = ()->
    oldrate = Rating.check $scope.recipe.id
    rate = if oldrate == 0 then 1 else oldrate*-1

    if Rating.rate $scope.recipe.id, rate
      $scope.setUserRate rate
      $scope.recipe.rating += rate
])