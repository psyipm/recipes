require 'paperclip'
require 'open-uri'
 
module Paperclip
  module CanAttachFromRemoteUrl
    module ClassMethods
 
      def can_attach_from_remote_url(name)
        attr_accessor "#{name}_remote_url"
 
        before_validation "download_remote_#{name}", :if => "#{name}_remote_url_provided?"
 
        define_method "#{name}_remote_url_provided?" do 
          self.send("#{name}_remote_url").present? && !self.send("#{name}").dirty?
        end
 
        define_method "download_remote_#{name}" do
          begin
            io = open(URI.parse(self.send("#{name}_remote_url")))
            if io
              def io.original_filename; base_uri.path.split('/').last; end
              io.original_filename.blank? ? nil : io
 
              send("#{name}=", io)
            end
          rescue 
            #TODO: should do some error handling (make invalid?)
            # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
          end
        end
      end
 
    end
 
    module Glue
      def self.included(base)
        base.extend ClassMethods
      end
    end
 
  end
end