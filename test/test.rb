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

class ControllerTest < Minitest::Test
  def test_get_top_memo
    get '/'
    assert last_response.ok?
    assert_equal '/', last_request.path_info
    assert_equal last_request.get?, true
  end

  def test_post_memo_param
    post '/new_memo', params = {
      'title':'title5',
      'text':'内容５'
    }
    assert_equal last_request.post?, true
    assert_equal last_request.form_data?, true
    follow_redirect!
    assert_equal '/', last_request.path_info
  end

  def test_get_memo_param
    get '/memo/1', params = {
      "title":"タイトル",
      "text":"内容１",
      "id":"1"
    }
    assert last_response.ok?
    assert_equal '/memo/1', last_request.path_info
    assert_equal last_request.get?, true
  end

  def test_get_edit_memo_param
    get '/memo/1/context', params = {
      "title":"タイトル",
      "text":"内容１",
      "id":"1"
    }
    assert last_response.ok?
    assert_equal '/memo/1/context', last_request.path_info
    assert_equal last_request.get?, true
  end

  def test_patch_memo_param
    patch '/memo/1/context', params = {
      'title':'title1変更',
      'text':'内容1変更'
    }
    assert_equal last_request.form_data?, true
    follow_redirect!
    assert_equal '/', last_request.path_info
  end

  def test_delete_memo_param
    delete '/memo/3', params = {
      "title":"タイトル３",
      "text":"内容３",
      "id":"3"
    }
    follow_redirect!
    assert_equal '/', last_request.path_info
  end

  def test_not_exist_page
    get '/unknown_path'
    assert_equal last_response.status, 404
  end

end
