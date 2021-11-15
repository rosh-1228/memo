# frozen_string_literal: true

helpers do
  def h(param)
    Rack::Utils.escape_html(param)
  end

  def import_json
    memo_file = File.open('json/memodb.json').read
    @memos = JSON.parse(memo_file) if memo_file != ''
  end

  def fetch_memo(memos, params)
    @memo = memos['memos'][fetch_memo_number(memos, params)]
  end
end
