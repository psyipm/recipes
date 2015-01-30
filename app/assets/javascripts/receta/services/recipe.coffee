angular.module('recetaServices')
.factory("Recipe", ['$http',
	($http)->
		return {
			find: (params, callback, offset = 0, limit = 10)->
				$http.post(
					'/recipes/find.json',
					{query: params, offset: offset, limit: limit}
				).success((data)->
					callback(data)
				)
		}
])