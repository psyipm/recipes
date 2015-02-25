require File.expand_path "lib/paperclip/can_attach_from_remote_url.rb", Rails.root

ActiveRecord::Base.send :include, Paperclip::CanAttachFromRemoteUrl::Glue