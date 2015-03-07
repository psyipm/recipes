# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://www.recipes4you.in.ua"

yandex = { :yandex => 'https://blogs.yandex.ru/pings/?status=success&url=%s' }
SitemapGenerator::Sitemap.search_engines.merge! yandex

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add all articles:
  #
    Recipe.where(published: true).find_each do |recipe|
      add recipe_path(recipe), :lastmod => recipe.updated_at, :priority => 1
    end

    add browse_path, :priority => 0.7, :changefreq => 'daily'

    pages = Recipe.where(published: true).length / Recipe.per_page

    pages.times do |n|
      page = n + 1
      add "#{browse_path}?page=#{page}", :changefreq => 'daily' if page > 1
    end

    Tag.cloud.find_each do |tag|
      add "#{browse_path}?#{URI.encode_www_form("tag" => tag.title)}"
    end
end