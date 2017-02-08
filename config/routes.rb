S3Browser::Engine.routes.draw do
  get 'buckets/:bucket_name' => 'buckets#index', as: 'buckets'
  post 'buckets/upload/:bucket_name' => 'buckets#upload', as: 'buckets_upload'
  post 'buckets/delete/:bucket_name' => 'buckets#delete', as: 'buckets_delete'
end
