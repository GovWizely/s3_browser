require 'aws-sdk-core'

module S3Browser
  class Bucket
    attr_accessor :name, :files
    CREDENTIALS = Aws::Credentials.new(S3Browser::Engine.aws_credentials[:access_key_id], S3Browser::Engine.aws_credentials[:secret_access_key])

    def initialize(bucket_name, s3=nil)
      @s3 = s3 ? s3 : Aws::S3::Client.new(region: S3Browser::Engine.aws_credentials[:region], credentials: CREDENTIALS)
      @name = bucket_name
      @files = @s3.list_objects(bucket: "#{@name}").contents
    end
    
    def upload(files)
      files.each do |file|
        @s3.put_object(bucket: "#{@name}", key: "#{file.original_filename}", body: file.read)
      end
    end

    def delete(filename)
      @s3.delete_object(bucket: "#{@name}", key: "#{filename}")
    end
  end
end
