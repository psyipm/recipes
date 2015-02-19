angular.module('recetaServices').service('Rating', ['localStorageService', (localStorageService)->
  _key = 'rated_recipes'
  
  _recipes = {
    liked: localStorageService.get(_key).liked or []
    disliked: localStorageService.get(_key).disliked or []
  }

  _persist = ()->
    localStorageService.set(_key, _recipes)

  _remove = (array, recipe_id)->
    index = _recipes[array].indexOf recipe_id
    if index != -1
      _recipes[array].splice index, 1
      _persist()
      return true
    return false

  _push = (array, recipe_id)->
    unless recipe_id in _recipes[array]
      _recipes[array].push recipe_id 
      _persist()
      return true
    return false

  return {
    like: (recipe_id)->
      _remove 'disliked', recipe_id
      result = _push 'liked', recipe_id

      #debug
      console.log localStorageService.get(_key)

      result

    dislike: (recipe_id)->
      _remove 'liked', recipe_id
      result = _push 'disliked', recipe_id

      #debug
      console.log localStorageService.get(_key)

      result

    rate: (recipe_id, rate)->
      console.log rate
      if rate > 0
        return @like(recipe_id)
      else if rate < 0
        return @dislike(recipe_id)
      else return false

    check: (recipe_id)->
      if recipe_id in _recipes.liked
        return 1 
      if recipe_id in _recipes.disliked
        return -1 

      return 0
  }
])