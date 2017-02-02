require 'aws-sdk-core'

module S3Browser
  class Bucket
    attr_accessor :name

    def initialize(bucket_name, s3=nil)
      @s3 = s3 ? s3 : Aws::S3::Client.new
      @name = bucket_name
    end
    
    def list_objects
      @s3.list_objects(bucket: "#{@name}")
    end

    def upload(file)
      @s3.put_object(bucket: "#{@name}", key: "#{file.original_filename}", body: file.read)
    end

    def delete(filename)
      @s3.delete_object(bucket: "#{@name}", key: "#{filename}")
    end
  end
end
