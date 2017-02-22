require_dependency "s3_browser/application_controller"

module S3Browser
  class BucketsController < ApplicationController
    before_filter :bucket, :only => [:index, :upload, :delete]

    def bucket
      begin
        @bucket = Bucket.new(params[:bucket_name])
      rescue
        @bad_bucket_name = params[:bucket_name]
        render :error
      end
    end

    def index
    end

    def upload
      @bucket.upload(params[:files])
      redirect_to buckets_path
    end

    def delete
      @bucket.delete(params[:filename_to_delete])
      redirect_to buckets_path
    end
  end
end
