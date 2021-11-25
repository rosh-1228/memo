require_relative './test.rb'

class ControllerTest < Minitest::Test
  def test_delete_memo_param
    delete '/memos/1', params = {
      'title':'test変更',
      'text':'test変更',
      'id':'1'
    }
    assert_equal last_request.delete?, true
    follow_redirect!
    assert_equal '/', last_request.path_info
  end
end