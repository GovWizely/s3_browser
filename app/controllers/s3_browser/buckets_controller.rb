require_dependency "s3_browser/application_controller"

module S3Browser
  class BucketsController < ApplicationController
    before_filter :bucket, :only => [:index, :upload, :delete]

    def bucket
      @bucket = Bucket.new(params[:bucket_name])
    end

    def index
      @file_names = @bucket.list_objects
    end

    def upload
      response = @bucket.upload(params[:file])
      redirect_to :action => "index", :bucket_name => params[:bucket_name]
    end

    def delete
      response = @bucket.delete(params[:filename_to_delete])
      redirect_to :action => "index", :bucket_name => params[:bucket_name]
    end
  end
end
