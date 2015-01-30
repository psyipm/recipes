angular.module('recetaServices')
.factory("Tag", ['$http',
	($http)->
		return {
			find: (query, callback)->
				$http.post(
					'/tags/find.json',
					{query: query.trim()}
				).success((data)->
					tags = (i.title for i in data)
					callback(tags)
				)
		}
])