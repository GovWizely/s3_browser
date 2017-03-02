require_dependency "s3_browser/application_controller"

module S3Browser
  class BucketsController < ApplicationController
    before_filter :bucket, :only => [:index, :upload, :delete]

    def bucket
      begin
        @bucket = Bucket.new(params[:bucket_name])
      rescue => e
        Rails.logger.error e
        @bad_bucket_name = params[:bucket_name]
        render :error
      end
    end

    def index
      @error_message = ''
    end

    def upload
      if params[:files].present?
        @bucket.upload(params[:files])
        redirect_to buckets_path
      else
        @error_message = 'Must select at least one file to upload.'
        render :index
      end
    end

    def delete
      if params[:filename_to_delete].present?
        @bucket.delete(params[:filename_to_delete])
        redirect_to buckets_path
      else
        @error_message = 'Must select a file to delete.'
        render :index
      end
    end
  end
end
