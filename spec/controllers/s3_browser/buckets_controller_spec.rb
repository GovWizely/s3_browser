require 'rails_helper'

module S3Browser
  RSpec.describe BucketsController, type: :controller do
    routes { S3Browser::Engine.routes }

    before(:all) do 
      class BucketDummy
        attr_accessor :name, :files

        def initialize(bucket_name)
          @name = bucket_name
          @files = ['one', 'two']
        end
        
        def upload(file)
          'file_uploaded'
        end

        def delete(filename)
          'file_deleted'
        end
      end
    end

    let(:bucket_name) { 'foo-bucket'}

    before(:each) { allow(Bucket).to receive(:new).and_return(BucketDummy.new(bucket_name)) }

    describe "GET index" do
      before  do
        get :index, bucket_name: bucket_name
      end

      it "renders the index template" do
        expect(response).to render_template("index")
      end
    end

    describe "GET upload" do
      before  do
        get :upload, bucket_name: bucket_name, file: 'pretend this is a file'
      end

      it "redirects to the index template" do
        expect(response).to redirect_to(:action => "index", :bucket_name => 'foo-bucket')
      end
    end

    describe "GET delete" do
      before  do
        get :delete, bucket_name: bucket_name, filename_to_delete: 'foo_file'
      end

      it "redirects to the index template" do
        expect(response).to redirect_to(:action => "index", :bucket_name => 'foo-bucket')
      end
    end

    describe '#bucket' do 
      before  do
        allow(Bucket).to receive(:new).and_raise(StandardError)
        get :index, bucket_name: bucket_name
      end
      it "renders an error message when there is trouble connecting to the bucket" do
        expect(response).to render_template(:error)
        expect(assigns(:bad_bucket_name)).to eq('foo-bucket')
      end
    end
  end
end
