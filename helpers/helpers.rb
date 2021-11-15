# frozen_string_literal: true

helpers do
  def h(param)
    Rack::Utils.escape_html(param)
  end

  def import_json
    @memos = FileTest.zero?('json/memodb.json') ? { 'memos' => [] } : JSON.parse(File.open('json/memodb.json').read)
  end

  def fetch_memo(memos, params)
    @memo = memos['memos'][fetch_memo_number(memos, params)]
  end

  def fetch_memo_number(memos, memo_param)
    memos['memos'].find_index { |data| data['id'].to_i == memo_param['id'].to_i }
  end

  def memos?(memos, params)
    memos['memos'] << params.merge!('id': memos['memos'][0].nil? ? 1 : memos['memos'][-1]['id'].to_i + 1)
    memos
  end

  def export_json(params)
    File.open('json/memodb.json', 'w') { |memodb| JSON.dump(params, memodb) }
  end

  def update_memo(memos, params)
    params.delete('_method')
    memos['memos'][fetch_memo_number(memos, params)].replace(params.transform_values! { |key| h(key) })
    export_json(memos)
  end
end
