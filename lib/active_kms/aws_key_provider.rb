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

    def decrypt(_, encrypted_data_key)
      client.decrypt(ciphertext_blob: encrypted_data_key).plaintext
    end

    # key is stored in ciphertext so don't need to store reference
    # reference could be useful for multiple AWS clients
    # so consider an option in the future
    def key_id_header
      "aws"
    end
  end
end
