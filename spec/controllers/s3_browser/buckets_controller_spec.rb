require 'rails_helper'

module S3Browser
  RSpec.describe BucketsController, type: :controller do
    routes { S3Browser::Engine.routes }

    describe "GET index" do
      before  do
        allow_any_instance_of(Bucket).to receive(:list_objects).and_return(['one', 'two'])
        get :index, bucket_name: 'foo-bucket'
      end

      it "assigns @file_names" do
        expect(assigns(:file_names)).to eq(['one', 'two'])
      end

      it "renders the index template" do
        expect(response).to render_template("index")
      end
    end

    describe "GET upload" do
      before  do
        allow_any_instance_of(Bucket).to receive(:upload).and_return('file uploaded')
        get :upload, bucket_name: 'foo-bucket', file: 'pretend this is a file'
      end

      it "redirects to the index template" do
        expect(response).to redirect_to(:action => "index", :bucket_name => 'foo-bucket')
      end
    end

    describe "GET index" do
      before  do
        allow_any_instance_of(Bucket).to receive(:delete).and_return('file deleted')
        get :delete, bucket_name: 'foo-bucket', filename_to_delete: 'foo_file'
      end

      it "redirects to the index template" do
        expect(response).to redirect_to(:action => "index", :bucket_name => 'foo-bucket')
      end
    end
  end
end
