source "https://rubygems.org"

gemspec

gem "rake"
gem "minitest"
gem "activerecord", "~> 8.1.0"
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
