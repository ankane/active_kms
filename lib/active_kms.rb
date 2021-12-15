# dependencies
require "active_support"

# modules
require "active_kms/base_key_provider"
require "active_kms/log_subscriber"
require "active_kms/version"

# providers
require "active_kms/aws_key_provider"
require "active_kms/google_cloud_key_provider"
require "active_kms/test_key_provider"
require "active_kms/vault_key_provider"

module ActiveKms
  class Error < StandardError; end
end

ActiveKms::LogSubscriber.attach_to :active_kms
