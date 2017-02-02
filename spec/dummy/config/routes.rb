Rails.application.routes.draw do

  mount S3Browser::Engine => "/s3_browser"
end
