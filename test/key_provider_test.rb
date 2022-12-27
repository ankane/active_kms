require_relative "test_helper"

class KeyProviderTest < Minitest::Test
  def setup
    User.delete_all
  end

  def test_create
    # should ideally be encrypt: 1 and no decrypt
    # https://github.com/rails/rails/issues/42388
    encrypt = ActiveRecord::VERSION::STRING.to_f >= 7.1 ? 1 : 3
    assert_operations encrypt: encrypt, decrypt: 1 do
      User.create!(email: "test@example.org")
    end
  end

  def test_assign
    user = User.new

    assert_operations do
      user.email = "test@example.org"
    end
  end

  def test_update
    user = User.create!(email: "test@example.org")

    # should ideally be encrypt: 1 and no decrypt
    # https://github.com/rails/rails/issues/42388
    encrypt = ActiveRecord::VERSION::STRING.to_f >= 7.1 ? 1 : 3
    assert_operations encrypt: encrypt, decrypt: 3 do
      user.update!(email: "test2@example.org")
    end
  end

  def test_query
    User.create!(email: "test@example.org")

    user =
      assert_operations do
        User.last
      end
    assert_operations decrypt: 1 do
      user.email
    end
    assert_operations do
      user.email
    end
  end

  private

  def assert_operations(**expected)
    $events.clear
    result = yield
    assert_equal expected.select { |k, v| v > 0 }, $events
    result
  end
end
