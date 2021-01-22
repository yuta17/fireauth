# Fireauth

Simple Firebase Authentication for Ruby.

The source of the idea is [this article](https://medium.com/@Mpierrax/firebase-authentification-with-ruby-on-rails-backend-a9f7afc4d715).

This gem takes the idToken issued by Firebase and sends the request to identitytoolkit.

And it will return the authenticated user's information.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fireauth'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install fireauth

## Configuration

t's needed to set up your Firebase API Key.

If you are using Rails, this should probably go into config/initializers/fireauth.rb.

```ruby
Fireauth.configure do |config|
  config.firebase_api_key = ENV['FIREBASE_API_KEY']
end
```

## Usage

```ruby
response = Fireauth::Authentication.call(id_token)
raise response['error']['message'] if response['error'].present?

authenticated_user = response['users'].first
```

### Payload Structure

A example of the payload structure from a Facebook login in JSON.

```json
{
   "kind": "identitytoolkit#GetAccountInfoResponse",
   "users": [
      {
         "localId": "dummyLocalId",
         "displayName": "dummyDisplayName",
         "photoUrl": "https://example.com/picture",
         "providerUserInfo": [
            {
               "providerId": "facebook.com",
               "displayName": "dummyDisplayName",
               "photoUrl": "https://example.com/picture",
               "federatedId": "00000000",
               "email": "dummy@example.com",
               "rawId": "0000000000"
            }
         ],
         "validSince": "1611130616",
         "lastLoginAt": "1611375910133",
         "createdAt": "1611130616888",
         "lastRefreshAt": "2021-01-23T04:25:10.840Z"
      }
   ]
}
```

Example for request with invalid id token.

```json
{
   "error": {
      "code": 400,
      "message": "INVALID_ID_TOKEN",
      "errors": [
         {
            "domain": "global",
            "message": "INVALID_ID_TOKEN",
            "reason": "invalid"
         }
      ],
      "status"
   }
}
```

## Development

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yuta17/fireauth.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
