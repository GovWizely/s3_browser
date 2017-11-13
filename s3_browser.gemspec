$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "s3_browser/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "s3_browser"
  s.version     = S3Browser::VERSION
  s.authors     = ["tmhammer"]
  s.email       = ["timh@govwizely.com"]
  s.homepage    = "https://github.com/GovWizely/s3_browser"
  s.summary     = "A simple interface for managing the files in a given S3 bucket."
  s.description = ""
  s.license     = "MIT"

  s.files = Dir["{app,config,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.0.9"
  s.add_dependency "aws-sdk-core", "~> 2.9"
  s.add_dependency "jquery-rails" 
  s.add_development_dependency "rspec-rails"
  s.add_dependency "codeclimate-test-reporter"
end
