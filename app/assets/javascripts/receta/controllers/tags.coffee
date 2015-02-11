angular.module('receta').controller('TagsController', ['$scope','$location'
  ($scope,$location)->
    $scope.addTag = ($event)->
      $event.preventDefault()
      text = $($event.target).text()
      search = $location.search()
      if search.hasOwnProperty("tags")
        tags = search.tags.split(",")
        tags.push text unless text in tags
        value = tags.join(",")
      else
        value = text
      $location.path("/").search($.extend true, search, {tags: value})

    $scope.clearTags = ($event)->
      $event.preventDefault()
      params = {}
      for key, val of $location.search()
        params[key] = val unless key is "tags"

      $location.path("/").search(params).replace()

    $(".tagcloud").tx3TagCloud()
])