class VkClient
	def initialize(offset, limit)
		@offset = offset
		@limit = limit * 2 # to filter ads and short posts

		@pages = ENV['vk_public_pages'].split("|")
		@vk = VkontakteApi::Client.new
	end
	
	def augment(recipes, params = [])
		query = build_query params
		@recipes = recipes

		data = if query.length > 0 then vk_search query else vk_get end

		limit = @limit / 2 - recipes.length
		result = Parse.get_posts(data).first(limit)

		Stalker.enqueue("recipes.save", recipes: result)

		return to_model result
	end

	def to_model(result) 
		result.each do |r|
			recipe = Recipe.new r[:recipe]
			recipe.photos = r[:photos].collect { |p| Photo.new p }

			@recipes.push recipe
		end
		@recipes
	end

	private
		def build_query(query)
			search_query = query.flatten(2).delete_if do |q|
				q.match /(tokens)|(tags)|(^$)/
			end
			search_query.join("|").mb_chars.downcase.to_s
		end

		def vk_search(query)
			@vk.wall.search owner_id: @pages.sample, query: query, offset: @offset, count: @limit
		end

		def vk_get
			@vk.wall.get owner_id: @pages.sample, offset: @offset, count: @limit
		end
end