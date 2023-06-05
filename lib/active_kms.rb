# dependencies
require "active_support"

# modules
require_relative "active_kms/base_key_provider"
require_relative "active_kms/log_subscriber"
require_relative "active_kms/version"

# providers
require_relative "active_kms/aws_key_provider"
require_relative "active_kms/google_cloud_key_provider"
require_relative "active_kms/test_key_provider"
require_relative "active_kms/vault_key_provider"

module ActiveKms
  class Error < StandardError; end
end

ActiveKms::LogSubscriber.attach_to :active_kms
