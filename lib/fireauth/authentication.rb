require 'faraday'
require 'json'

module Fireauth
  class Authentication
    IDENTITY_URL = "https://www.googleapis.com/identitytoolkit/v3/relyingparty/getAccountInfo"

    # @example
    #   response = Fireauth::Authentication.call(id_token)
    #
    # @param [String] id_token Firebase ID Token
    # @return [Hash] authenticated user or error message
    def self.call(id_token)
      new(id_token).response
    end

    def initialize(id_token)
      @id_token = id_token
      @firebase_api_key = Fireauth.configuration.firebase_api_key
    end

    def response
      JSON.parse(request.body)
    end

    private

    attr_reader :id_token, :firebase_api_key

    def request
      url = "#{IDENTITY_URL}?key=#{firebase_api_key}"
      request_body = "{ 'idToken': '#{id_token}' }"

      Faraday.post(url, request_body, content_type: 'application/json')
    end
  end
end
