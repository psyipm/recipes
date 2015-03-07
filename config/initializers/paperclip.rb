require File.expand_path "lib/paperclip/can_attach_from_remote_url.rb", Rails.root

ActiveRecord::Base.send :include, Paperclip::CanAttachFromRemoteUrl::Glue

Paperclip::Attachment.default_options.update({
  :url => "/system/:attachment/:id_partition/:hash.:extension",
  :hash_data => ":class/:attachment/:id/:style",
  :hash_secret => ENV['paperclip_random_secret']
})