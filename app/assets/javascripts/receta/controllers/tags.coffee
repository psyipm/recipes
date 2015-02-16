receta = angular.module('receta')
receta.controller('TagsController', ['$scope','$location','$modal',
  ($scope,$location,$modal)->
    $scope.multiTagSearch = false

    $scope.openSettings = ()->
      $scope.modalInstance = $modal.open({
        templateUrl: 'tags/tagcloud_settings.html'
        scope: $scope
        resolve: ()->
          return $scope.multiTagSearch
        controller: 'TagCloudSettingsModalController'
      })

      $scope.modalInstance.result.then (isMulti)->
        $scope.multiTagSearch = isMulti

    $scope.add = (text, search)->
      if search.hasOwnProperty("tags")
        tags = search.tags.split(",")
        tags.push text unless text in tags
        value = tags.join(",")
      else
        value = text
      $location.path("/").search($.extend true, search, {tags: value})

    $scope.replace = (text, search)->
      $location.path("/").search($.extend true, search, {tags: text})

    $scope.addTag = ($event)->
      $event.preventDefault()
      text = $($event.target).text()
      search = $location.search()

      if $scope.multiTagSearch
        $scope.add(text, search)
      else
        $scope.replace(text, search)

    $scope.clearTags = ($event)->
      $event.preventDefault()
      params = {}
      for key, val of $location.search()
        params[key] = val unless key is "tags"

      $location.path("/").search(params).replace()

    $(".tagcloud").tx3TagCloud()
])

receta.controller('TagCloudSettingsModalController', ['$scope', ($scope)->
  $scope.setValue = (value)->
    $scope.multiTagSearch = value
    
  $scope.ok = ()->
    $scope.modalInstance.close($scope.multiTagSearch)
])