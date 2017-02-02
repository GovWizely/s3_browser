S3Browser::Engine.routes.draw do
  get 'buckets/:bucket_name' => 'buckets#index'
  post 'buckets/upload' => 'buckets#upload'
  post 'buckets/delete' => 'buckets#delete'
end
