angular.module('recetaServices')
.factory("Component", ['$http',
	($http)->
		return {
			find: (query, callback)->
				$http.post(
					'/components/find.json',
					{query: query.trim()}
				).success((data)->
					components = (i.title for i in data)
					callback(components)
				)

			get: (callback)->
				$http.post(
					'/components/get.json', {}
				).success((data)->
					callback(data)
				)
		}
])