module S3Browser
  class Engine < ::Rails::Engine
    isolate_namespace S3Browser

    class << self
      mattr_accessor :aws_credentials
      self.aws_credentials = {
        access_key_id:     'not a key',
        secret_access_key: 'also not a key',
        region:             'us-east-1'
      }
    end

    def self.setup(&block)
      yield self
    end
  end
end
