module ActiveKms
  class VaultKeyProvider < BaseKeyProvider
    private

    def default_client
      Vault::Client.new
    end

    def encrypt(key_id, data_key)
      client.logical.write("transit/encrypt/#{key_id}", plaintext: Base64.encode64(data_key)).data[:ciphertext]
    end

    def decrypt(key_id, encrypted_data_key)
      Base64.decode64(client.logical.write("transit/decrypt/#{key_id}", ciphertext: encrypted_data_key).data[:plaintext])
    end

    # could store entire key_id in key_id_header but prefer reference
    def prefix
      "vt"
    end
  end
end
