ENV['APP_ENV'] = 'test'

require_relative '../app'
require 'test/unit'
require 'rack/test'
require 'minitest/autorun'

connect = PG.connect( dbname: 'memos')

connect.exec('DROP TABLE memos')
connect.exec('CREATE TABLE memos( id SERIAL, title TEXT NOT NULL, context TEXT )')

class Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
end

class ControllerTest < Minitest::Test

  def test_memo
    get '/'
    assert last_response.ok?
    assert_equal '/', last_request.path_info
    assert_equal last_request.get?, true

    post '/memos', params = {
      'title':'test',
      'context':'test'
    }
    assert_equal last_request.post?, true
    assert_equal last_request.form_data?, true
    follow_redirect!
    assert_equal '/', last_request.path_info

    get '/memos/1', params = {
      'id':'1'
    }
    assert last_response.ok?
    assert_equal '/memos/1', last_request.path_info
    assert_equal last_request.get?, true

    get '/memos/1/edit', params = {
      'id':'1'
    }
    assert last_response.ok?
    assert_equal '/memos/1/edit', last_request.path_info
    assert_equal last_request.get?, true

    patch '/memos/1', params = {
      'title':'test変更',
      'context':'test変更',
      'id':'1'
    }
    assert_equal last_request.patch?, true
    assert_equal last_request.form_data?, true
    follow_redirect!
    assert_equal '/', last_request.path_info

    delete '/memos/1', params = {
      'id':'1'
    }
    assert_equal last_request.delete?, true
    follow_redirect!
    assert_equal '/', last_request.path_info

    get '/unknown_path'
    assert_equal last_response.status, 404
  end
end