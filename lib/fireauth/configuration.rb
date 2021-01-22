module Fireauth
  class Configuration
    attr_accessor :firebase_api_key

    def initialize
      @firebase_api_key = ''
    end
  end
end
