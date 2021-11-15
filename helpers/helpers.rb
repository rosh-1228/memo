# frozen_string_literal: true

helpers do
  def h(param)
    Rack::Utils.escape_html(param)
  end

  def import_json
=begin
    memo_file = File.open('json/memodb.json').read
    p memo_file
    @memos = JSON.parse(memo_file) if memo_file != ''
=end
    @memos = FileTest.zero?('json/memodb.json')? nil : JSON.parse(File.open('json/memodb.json').read)
  end

  def fetch_memo(memos, params)
    @memo = memos['memos'][fetch_memo_number(memos, params)]
  end

  def fetch_memo_number(memos, memo_param)
    memos['memos'].find_index { |data| data['id'].to_i == memo_param['id'].to_i }
  end

  def memos?(memos, params)
    params.transform_values! { |key| h(key) }
    if memos.nil? || memos['memos'][0].nil?
      memos = { 'memos' => [params.merge!('id': 1)] }
    else
      memos['memos'] << params.merge!('id': memos['memos'][-1]['id'].to_i + 1)
    end
    memos
  end

  def export_json(params)
    File.open('json/memodb.json', 'w') { |memodb| JSON.dump(params, memodb) }
  end

  def update_memo(memos, params)
    params.delete('_method')
    params.transform_values! { |key| h(key) }
    memos['memos'][fetch_memo_number(memos, params)].replace(params)
    export_json(memos)
  end
end

configure do
  use Rack::Flash
end

enable :sessions
