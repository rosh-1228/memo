# frozen_string_literal: true

helpers do
  def h(param)
    Rack::Utils.escape_html(param)
  end

  def memos?(memos, params)
    memos['memos'] << params.merge!('id': memos['memos'][0].nil? ? '1' : (memos['memos'][-1]['id'].to_i + 1).to_s)
    memos
  end

  def export_json(params)
    File.open('json/memodb.json', 'w') { |memodb| JSON.dump(params, memodb) }
  end

  def update_memo(memos, params)
    params.delete('_method')
    memos['memos'][fetch_memo_number(memos, params)].replace(params)
    export_json(memos)
  end
end
