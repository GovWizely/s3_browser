require 'rails_helper'

module S3Browser
  RSpec.describe Bucket, type: :model do
  
    before(:all) do 
      class FileDummy
        def initialize(name)
          @name = name
        end
        def original_filename
          @name
        end
        def read
          'content'
        end
      end

      class S3ResponseDummy
        def contents
          ['one', 'two']
        end
      end

      class S3Dummy
        def list_objects(params)
          S3ResponseDummy.new
        end
        def put_object(params)
        end
        def delete_object(params)
          'delete response'
        end
      end
    end

    let(:s3) { S3Dummy.new }

    before(:each) do 
      @bucket = Bucket.new('foo-bucket', s3)
    end 

    describe '#initialze' do
      it "sets the bucket name and object list" do
        expect(@bucket.name).to eq('foo-bucket')
        expect(@bucket.files).to eq(['one', 'two'])
      end
    end

    describe '#upload' do
      it "uploads the objects to s3" do
        expect(s3).to receive(:put_object).with(bucket: 'foo-bucket', key: 'f1_file.txt', body: 'content')
        expect(s3).to receive(:put_object).with(bucket: 'foo-bucket', key: 'f2_file.txt', body: 'content')
        files = [FileDummy.new('f1_file.txt'), FileDummy.new('f2_file.txt')]
        expect(@bucket.upload(files)).to be_truthy
      end
    end

    describe '#delete' do
      it "deletes the object from s3" do
        expect(s3).to receive(:delete_object).with(bucket: 'foo-bucket', key: 'key').and_return('delete response')
        expect(@bucket.delete('key')).to eq('delete response')
      end
    end
  end
end
