class Parse
	def self.get_title_from_text(text)
		arr = text.split("<br>")
		title = arr.delete_at 0
		text = arr.join("<br>")
		
		return title, text
	end

	def self.get_attached_photos(attachments)
		photos = Array.new
		attachments.each do |a|
			next unless a.is_a? Hashie::Mash and a.key? 'photo'
			photo = { original: a.photo.src_xxxbig || a.photo.src_xxbig || a.photo.src_xbig || a.photo.src_big, medium: a.photo.src_big, thumb: nil }
			photos.push photo
		end
		photos
	end

	def self.get_posts(vk_data, min_len = 500, max_len = 2000)
		posts = Array.new
		vk_data.each do |d|
			next unless can_be_parsed? d, min_len, max_len
			begin
				title, text = get_title_from_text d.text
				photos = get_attached_photos [d.attachment] + d.attachments
				recipe = { recipe: { id: nil, title: title, text: text, serving: nil, cook_time: nil, rating: nil, published: true }, photos: photos }
				posts.push recipe
			rescue Exception => e
				# ignore, and go next
				next
			end
		end
		posts
	end

	private
		def self.can_be_parsed? (item, min_len, max_len)
			return false unless item.is_a? Hashie::Mash
			return false unless item.key? 'text' and item.key? 'attachments'
			return false unless item.text.length > min_len and item.text.length < max_len

			return true
		end
end