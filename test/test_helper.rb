require "bundler/setup"
Bundler.require(:default)
require "minitest/autorun"
require "minitest/pride"
require "active_record"

ENV["VAULT_ADDR"] ||= "http://127.0.0.1:8200"

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

logger = ActiveSupport::Logger.new(ENV["VERBOSE"] ? STDOUT : nil)
Aws.config[:logger] = logger
ActiveRecord::Base.logger = logger
ActiveSupport::LogSubscriber.logger = logger

ActiveRecord::Migration.verbose = ENV["VERBOSE"]

ActiveRecord::Schema.define do
  create_table :users do |t|
    t.string :email
  end
end

class User < ActiveRecord::Base
  encrypts :email
end

key_provider =
  case ENV["KEY_PROVIDER"]
  when "aws"
    ActiveKms::AwsKeyProvider.new(key_id: ENV.fetch("KEY_ID"))
  when "google"
    ActiveKms::GoogleCloudKeyProvider.new(key_id: ENV.fetch("KEY_ID"))
  when "vault"
    ActiveKms::VaultKeyProvider.new(key_id: ENV.fetch("KEY_ID"))
  when "test", nil
    ActiveKms::TestKeyProvider.new
  else
    raise "Invalid key provider"
  end

ActiveRecord::Encryption.configure(
  key_provider: key_provider,
  # https://github.com/rails/rails/issues/42385
  primary_key: "secret",
  key_derivation_salt: "secret",
  deterministic_key: nil
)

$events = Hash.new(0)
ActiveSupport::Notifications.subscribe(/active_kms/) do |name, _start, _finish, _id, _payload|
  $events[name.sub(".active_kms", "").to_sym] += 1
end
