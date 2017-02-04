require 'rails_helper'

module S3Browser
  RSpec.describe Bucket, type: :model do
  
    before(:all) do 
      class S3Dummy
        def list_objects(params)
          ['one', 'two']
        end

        def put_object(params)
          'put response'
        end

        def delete_object(params)
          'delete response'
        end
      end

      class FileDummy
        def original_filename
          'key'
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
    end

    let(:s3) { S3Dummy.new }

    before(:each) do 
      expect(s3).to receive(:list_objects).with(bucket: 'foo-bucket').and_return(S3ResponseDummy.new)
      @bucket = Bucket.new('foo-bucket', s3)
    end 

    describe '#initialze' do
      it "sets the bucket name and object list" do
        expect(@bucket.name).to eq('foo-bucket')
        expect(@bucket.files).to eq(['one', 'two'])
      end
    end

    describe '#upload' do
      it "uploads the object to s3" do
        expect(s3).to receive(:put_object).with(bucket: 'foo-bucket', key: 'key', body: 'content').and_return('put response')
        expect(@bucket.upload(FileDummy.new)).to eq('put response')
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
