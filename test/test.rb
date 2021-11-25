ENV['APP_ENV'] = 'test'

require_relative '../app'
require 'test/unit'
require 'rack/test'
require 'minitest/autorun'

class Minitest::Test
  include Rack::Test::Methods
  def app
    Sinatra::Application
  end
end
