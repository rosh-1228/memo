# frozen_string_literal: true

helpers do
  def import_json
    @memos = begin
      FileTest.zero?('json/memodb.json') ? { 'memos' => [] } : JSON.parse(File.open('json/memodb.json').read)
    rescue JSON::ParserError
      { 'memos' => [] }
    end
  end

  def fetch_memo(memos, params)
    @memo = memos['memos'][fetch_memo_number(memos, params)]
  end

  def fetch_memo_number(memos, params)
    memos['memos'].find_index { |data| data['id'].to_i == params['id'].to_i }
  end
end
