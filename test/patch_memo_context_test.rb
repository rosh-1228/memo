require_relative './test.rb'

class ControllerTest < Minitest::Test
  def test_patch_memo_param
    patch '/memos/1/contexts', params = {
      'title':'test変更',
      'text':'test変更'
    }
    assert_equal last_request.patch?, true
    assert_equal last_request.form_data?, true
    follow_redirect!
    assert_equal '/', last_request.path_info
  end
end