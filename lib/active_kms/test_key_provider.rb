module ActiveKms
  class TestKeyProvider < BaseKeyProvider
    def initialize
    end

    private

    def encrypt(_, data_key)
      data_key
    end

    def decrypt(_, encrypted_data_key)
      encrypted_data_key
    end

    def key_id_header
      "test"
    end
  end
end
