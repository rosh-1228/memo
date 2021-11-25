require_relative './test.rb'

class ControllerTest < Minitest::Test
  def test_not_exist_page
    get '/unknown_path'
    assert_equal last_response.status, 404
  end
end