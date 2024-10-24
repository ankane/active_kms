module ActiveKms
  class AwsKeyProvider < BaseKeyProvider
    private

    def default_client
      Aws::KMS::Client.new(
        retry_limit: 1,
        http_open_timeout: 2,
        http_read_timeout: 2
      )
    end

    def encrypt(key_id, data_key)
      client.encrypt(key_id: key_id, plaintext: data_key).ciphertext_blob
    end

    def decrypt(key_id, encrypted_data_key)
      client.decrypt(key_id: key_id, ciphertext_blob: encrypted_data_key).plaintext
    end

    # the same key can be referenced multiple ways
    # (key ID, key ARN, alias name, alias ARN)
    # but not a great way to account for this
    def prefix
      "aws"
    end
  end
end
