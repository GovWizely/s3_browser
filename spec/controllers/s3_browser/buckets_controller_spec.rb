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
        
        def upload(files)
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
      context 'when one or more files are selected' do
        before { get :upload, bucket_name: bucket_name, files: ['array', 'of', 'files'] }
        it "redirects to the index template" do
          expect(response).to redirect_to(:action => "index", :bucket_name => 'foo-bucket')
        end
      end

      context 'when no file is selected' do
        before { get :upload, bucket_name: bucket_name, files: nil }
        it "rerenders the form with an error message" do
          expect(response).to render_template(:index)
          expect(assigns(:error_message)).to eq('Must select at least one file to upload.')
        end
      end
    end

    describe "GET delete" do
      context 'when a file is selected for deletion' do 
        before { get :delete, bucket_name: bucket_name, filename_to_delete: 'foo_file' }
        it "redirects to the index template" do
          expect(response).to redirect_to(:action => "index", :bucket_name => 'foo-bucket')
        end
      end

      context 'when no file is selected' do
        before { get :delete, bucket_name: bucket_name, filename_to_delete: nil }
        it "rerenders the form with an error message" do
          expect(response).to render_template(:index)
          expect(assigns(:error_message)).to eq('Must select a file to delete.')
        end
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
