require_relative './test.rb'

class ControllerTest < Minitest::Test
  def test_get_memo_param
    get '/memos/1', params = {
      'title':'test',
      'text':'test',
      'id':'1'
    }
    assert last_response.ok?
    assert_equal '/memos/1', last_request.path_info
    assert_equal last_request.get?, true
  end
end