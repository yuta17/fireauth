require "fireauth/version"
require "fireauth/configuration"
require "fireauth/authentication"

module Fireauth
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration
  end
end
