Rails.application.config.middleware.use OmniAuth::Builder do
  provider :vkontakte,					ENV['vk_app_id'],							ENV['vk_app_secret']
  provider :github,							ENV['github_client_id'],			ENV['github_client_secret'],  		 scope: 'email,profile'
  provider :facebook,						ENV['facebook_app_id'],				ENV['facebook_app_secret']
  provider :twitter,						ENV['twitter_api_key'],				ENV['twitter_api_secret']
end