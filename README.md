# Active KMS

Simple, secure key management for [Active Record encryption](https://edgeguides.rubyonrails.org/active_record_encryption.html)

**Note:** At the moment, encryption requires three encryption requests and one decryption request. See [this Rails issue](https://github.com/rails/rails/issues/42388) for more info. As a result, there’s no way to grant encryption and decryption permission separately.

For Lockbox and attr_encrypted, check out [KMS Encrypted](https://github.com/ankane/kms_encrypted)

[![Build Status](https://github.com/ankane/active_kms/workflows/build/badge.svg?branch=master)](https://github.com/ankane/active_kms/actions)

## Installation

Add this line to your application’s Gemfile:

```ruby
gem "active_kms"
```

And follow the instructions for your key management service:

- [AWS KMS](#aws-kms)
- [Google Cloud KMS](#google-cloud-kms)
- [Vault](#vault)

### AWS KMS

Add this line to your application’s Gemfile:

```ruby
gem "aws-sdk-kms"
```

Create an [Amazon Web Services](https://aws.amazon.com/) account if you don’t have one. KMS works great whether or not you run your infrastructure on AWS.

Create a [KMS master key](https://console.aws.amazon.com/kms/home#/kms/keys) and set it in your environment along with your AWS credentials ([dotenv](https://github.com/bkeepers/dotenv) is great for this)

```sh
KMS_KEY_ID=alias/my-key
AWS_ACCESS_KEY_ID=...
AWS_SECRET_ACCESS_KEY=...
```

And add to `config/application.rb`:

```ruby
config.active_record.encryption.key_provider = ActiveKms::AwsKeyProvider.new(key_id: ENV["KMS_KEY_ID"])
```

### Google Cloud KMS

Add this line to your application’s Gemfile:

```ruby
gem "google-cloud-kms"
```

Create a [Google Cloud Platform](https://cloud.google.com/) account if you don’t have one. KMS works great whether or not you run your infrastructure on GCP.

Create a [KMS key ring and key](https://console.cloud.google.com/iam-admin/kms) and set it in your environment along with your GCP credentials ([dotenv](https://github.com/bkeepers/dotenv) is great for this)

```sh
KMS_KEY_ID=projects/my-project/locations/global/keyRings/my-key-ring/cryptoKeys/my-key
```

And add to `config/application.rb`:

```ruby
config.active_record.encryption.key_provider = ActiveKms::GoogleCloudKeyProvider.new(key_id: ENV["KMS_KEY_ID"])
```

### Vault

Add this line to your application’s Gemfile:

```ruby
gem "vault"
```

Enable the [transit](https://www.vaultproject.io/docs/secrets/transit/index.html) secrets engine

```sh
vault secrets enable transit
```

And create a key

```sh
vault write -f transit/keys/my-key
```

Set it in your environment along with your Vault credentials ([dotenv](https://github.com/bkeepers/dotenv) is great for this)

```sh
KMS_KEY_ID=my-key
VAULT_ADDR=http://127.0.0.1:8200
VAULT_TOKEN=secret
```

And add to `config/application.rb`:

```ruby
config.active_record.encryption.key_provider = ActiveKms::VaultKeyProvider.new(key_id: ENV["KMS_KEY_ID"])
```

## Per-Attribute Keys

Specify per-attribute keys

```ruby
class User < ApplicationRecord
  encrypts :email, key_provider: ActiveKms::AwsKeyProvider.new(key_id: "...")
end
```

## Testing

For testing, you can prevent network calls to KMS by adding to `config/environments/test.rb`:

```ruby
config.active_record.encryption.key_provider = ActiveKms::TestKeyProvider.new
```

## Key Rotation

Key management services allow you to rotate the master key without any code changes.

- For AWS KMS, you can use [automatic key rotation](https://docs.aws.amazon.com/kms/latest/developerguide/rotate-keys.html)
- For Google Cloud, use the Google Cloud Console or API
- For Vault, use:

```sh
vault write -f transit/keys/my-key/rotate
```

New data will be encrypted with the new master key version. To encrypt existing data with new master key version, run:

```ruby
User.find_each do |user|
  user.encrypt
end
```

### Switching Keys

You can change keys within your current KMS or move to a different KMS without downtime.

Set globally in `config/application.rb`:

```ruby
config.active_record.encryption.previous = [{key_provider: ActiveKms::AwsKeyProvider.new(key_id: "...")}]
```

Or per-attribute:

```ruby
class User < ApplicationRecord
  encrypts :email, previous: [{key_provider: ActiveKms::AwsKeyProvider.new(key_id: "...")}]
end
```

## Reference

Specify a client

```ruby
ActiveKms::AwsKeyProvider.new(client: Aws::KMS::Client.new, ...)
# or
ActiveKms::GoogleCloudKeyProvider.new(client: Google::Cloud::Kms.key_management_service, ...)
# or
ActiveKms::VaultKeyProvider.new(client: Vault::Client.new, ...)
```

## History

View the [changelog](https://github.com/ankane/active_kms/blob/master/CHANGELOG.md)

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/active_kms/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/active_kms/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

To get started with development:

```sh
git clone https://github.com/ankane/active_kms.git
cd active_kms
bundle install
bundle exec rake test
```
