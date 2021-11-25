require_relative './test.rb'

File.open('json/memodb.json', 'w') { |memodb| JSON.dump({'memos':[]}, memodb) }

class ControllerTest < Minitest::Test
  def test_post_memo_param
    post '/memos', params = {
      'title':'test',
      'text':'test'
    }
    assert_equal last_request.post?, true
    assert_equal last_request.form_data?, true
    follow_redirect!
    assert_equal '/', last_request.path_info
  end
end
