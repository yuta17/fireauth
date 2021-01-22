require 'spec_helper'

RSpec.describe Fireauth::Authentication do
  let(:request_url) { "#{Fireauth::Authentication::IDENTITY_URL}?key=#{firebase_api_key}" }

  before do
    Fireauth.configure do |config|
      config.firebase_api_key = firebase_api_key
    end

    WebMock.enable!
  end

  describe '#call' do
    subject(:response) { Fireauth::Authentication.call(id_token) }

    context 'when invalid firebase_api_key' do
      let(:firebase_api_key) { 'invalid' }

      before do
        stub_request(:post, request_url).to_return(
          body: "{\n  \"error\": {\n    \"code\": 400,\n    \"message\": \"API key not valid. Please pass a valid API key.\",\n    \"errors\": [\n      {\n        \"message\": \"API key not valid. Please pass a valid API key.\",\n        \"domain\": \"global\",\n        \"reason\": \"badRequest\"\n      }\n    ],\n    \"status\": \"INVALID_ARGUMENT\"\n  }\n}\n",
          status: 400
        )
      end

      context 'when valid id_token' do
        let(:id_token) { 'valid' }

        it 'returns hash with error' do
          expect(response['error'].empty?).to be false
        end
      end
    end

    context 'when valid firebase_api_key' do
      let(:firebase_api_key) { 'valid' }

      context 'when valid id_token' do
        let(:id_token) { 'valid' }

        before do
          stub_request(:post, request_url).to_return(
            body: "{\n  \"kind\": \"identitytoolkit#GetAccountInfoResponse\",\n  \"users\": [\n    {\n      \"localId\": \"dummyLocalId\",\n      \"displayName\": \"dummyDisplayName\",\n      \"photoUrl\": \"https://example.com/picture\",\n      \"providerUserInfo\": [\n        {\n          \"providerId\": \"facebook.com\",\n          \"displayName\": \"dummyDisplayName\",\n          \"photoUrl\": \"https://example.com/picture\",\n          \"federatedId\": \"00000000\",\n          \"email\": \"dummy@example.com\",\n          \"rawId\": \"0000000000\"\n        }\n      ],\n      \"validSince\": \"1611130616\",\n      \"lastLoginAt\": \"1611375910133\",\n      \"createdAt\": \"1611130616888\",\n      \"lastRefreshAt\": \"2021-01-23T04:25:10.840Z\"\n    }\n  ]\n}\n",
            status: 200
          )
        end

        it 'returns authenticated user' do
          user = response['users'].first
          provider_user_info = user['providerUserInfo'].first

          expect(user['localId']).to eq('dummyLocalId')
          expect(provider_user_info['email']).to eq('dummy@example.com')
        end
      end

      context 'when invalid id_token' do
        let(:id_token) { 'invalid' }

        before do
          stub_request(:post, request_url).to_return(
            body: "{\n  \"error\": {\n    \"code\": 400,\n    \"message\": \"INVALID_ID_TOKEN\",\n    \"errors\": [\n      {\n        \"message\": \"INVALID_ID_TOKEN\",\n        \"domain\": \"global\",\n        \"reason\": \"invalid\"\n      }\n    ]\n  }\n}\n",
            status: 400
          )
        end

        it 'returns hash with error' do
          expect(response['error'].empty?).to be false
        end
      end
    end
  end
end
