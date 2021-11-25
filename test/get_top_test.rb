require_relative './test.rb'

class ControllerTest < Minitest::Test
  def test_get_top_memo
    get '/'
    assert last_response.ok?
    assert_equal '/', last_request.path_info
    assert_equal last_request.get?, true
  end
end
