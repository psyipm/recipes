angular.module('receta').factory('RecipeService', [
	'Restangular', 'Recipe', '$auth', 'queryCache',
	(Restangular, Recipe, $auth, queryCache)->
		model = 'recipes'

		Restangular.extendModel(model, (obj)->
			angular.extend(obj, Recipe)
		)

		headers = $auth.retrieveData('auth_headers')

		find: (params, offset = 0, limit = 10)-> 
			query = {query: params, offset: offset, limit: limit}
			callback = ()->
				Restangular.all(model)
					.customPOST(query, 'find.json', null, headers)

			queryCache.fromCache(query, callback)
			# callback()

		create: (recipe)->
			Restangular.all(model).post(recipe, null, headers)

		one: (id)->
			Restangular.one(model, id).post()

		put: (recipe)->
			Restangular.all(model)
				.customPUT(recipe, "#{recipe.id}", null, headers)

		remove: (id)->
			Restangular.one(model, id).remove(null, headers)

		edit: (id)->
			Restangular.oneUrl(model, "#{model}/#{id}/edit", id).post(null, null, null, headers)

		update_rating: (id, rate)->
			Restangular.oneUrl(model, "#{model}/#{id}/rating", id)
				.customPOST({id: id, rate: rate}, null, null, headers)

		per_page: 10
])