module ActiveKms
  class GoogleCloudKeyProvider < BaseKeyProvider
    private

    def default_client
      require "google/cloud/kms"

      Google::Cloud::Kms.key_management_service do |config|
        config.timeout = 2
      end
    end

    def encrypt(key_id, data_key)
      client.encrypt(name: key_id, plaintext: data_key).ciphertext
    end

    def decrypt(key_id, encrypted_data_key)
      client.decrypt(name: key_id, ciphertext: encrypted_data_key).plaintext
    end

    def prefix
      "gc"
    end
  end
end
