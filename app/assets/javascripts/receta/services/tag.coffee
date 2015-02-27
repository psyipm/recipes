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

			for_recipe: (recipe_id, callback, limit = 200)->
				$http.post(
					"/recipes/#{recipe_id}/tags",
					{limit: limit}
				).success((tags)->
					callback tags
				)

			create: (title, recipe_id, callback)->
				$http.post(
					"/tags",
					{title: title, recipe_id: recipe_id}
				).success((data)->
					callback data.tag
				)

			parse_from_cloud: ()->
				data = []
				$(".tagcloud li a").each(()-> data.push $(this).text())
				data
		}
])