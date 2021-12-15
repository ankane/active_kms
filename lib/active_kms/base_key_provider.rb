module ActiveKms
  class BaseKeyProvider
    attr_reader :key_id, :client

    def initialize(key_id:, client: nil)
      @key_id = key_id
      @client = client || default_client
    end

    def encryption_key
      data_key = ActiveRecord::Encryption.key_generator.generate_random_key
      encrypted_data_key =
        ActiveSupport::Notifications.instrument("encrypt.active_kms") do
          encrypt(key_id, data_key)
        end

      key = ActiveRecord::Encryption::Key.new(data_key)
      key.public_tags.encrypted_data_key = encrypted_data_key
      key.public_tags.encrypted_data_key_id = key_id_header
      key
    end

    def decryption_keys(encrypted_message)
      return [] if encrypted_message.headers.encrypted_data_key_id != key_id_header

      encrypted_data_key = encrypted_message.headers.encrypted_data_key
      # rescue errors to try previous keys
      # rescue outside Active Support notification for more intuitive output
      begin
        data_key =
          ActiveSupport::Notifications.instrument("decrypt.active_kms") do
            decrypt(key_id, encrypted_data_key)
          end
        [ActiveRecord::Encryption::Key.new(data_key)]
      rescue => e
        warn "[active_kms] #{e.class.name}: #{e.message}"
        []
      end
    end

    private

    def key_id_header
      @key_id_header ||= "#{prefix}/#{Digest::SHA1.hexdigest(key_id).first(4)}"
    end
  end
end
