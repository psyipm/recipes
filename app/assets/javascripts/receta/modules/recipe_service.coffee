angular.module('receta').factory('RecipeService', [
	'Restangular', 'Recipe', '$auth',
	(Restangular, Recipe, $auth)->
		model = 'recipes'

		Restangular.extendModel(model, (obj)->
			angular.extend(obj, Recipe)
		)

		find: (params, offset = 0, limit = 10)-> 
			Restangular.all(model)
				.customPOST({query: params, offset: offset, limit: limit}, 'find.json')

		create: (recipe)->
			headers = $auth.retrieveData('auth_headers')
			Restangular.all(model).post(recipe, null, headers)
])