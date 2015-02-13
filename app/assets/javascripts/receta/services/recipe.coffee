angular.module('receta').factory('RecipeService', [
	'Restangular', 'Recipe', '$auth',
	(Restangular, Recipe, $auth)->
		model = 'recipes'

		Restangular.extendModel(model, (obj)->
			angular.extend(obj, Recipe)
		)

		headers = $auth.retrieveData('auth_headers')

		find: (params, offset = 0, limit = 10)-> 
			Restangular.all(model)
				.customPOST({query: params, offset: offset, limit: limit}, 'find.json', null, headers)

		create: (recipe)->
			Restangular.all(model).post(recipe, null, headers)

		one: (id)->
			Restangular.one(model, id).post()

		put: (recipe)->
			Restangular.all(model)
				.customPUT(recipe, "#{recipe.id}", null, headers)

		remove: (id)->
			Restangular.one(model, id).remove(null, headers)
])