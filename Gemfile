source "https://rubygems.org"

gemspec

gem "rake"
gem "minitest", ">= 5"
gem "activerecord", "~> 8.0.0"

gem "aws-sdk-kms"
gem "vault"
gem "nokogiri" # for aws-sdk

platform :ruby do
  gem "sqlite3"
  gem "google-cloud-kms"
end

platform :jruby do
  gem "sqlite3-ffi"
end
