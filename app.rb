# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

def import_json
  File.open('json/memodb.json') do |memo|
    JSON.parse(memo.read)
  end
end

memos = import_json

def fetch_memo(memos, memo_param)
  memos['memos'].find_index { |data| data['id'].to_i == memo_param['id'].to_i }
end

def update_memo(memos, memo_params)
  memo_params.delete('_method')
  memos['memos'][fetch_memo(memos, memo_params)].replace(memo_params)
  memos
end

def export_json(memo_params)
  File.open('json/memodb.json', 'w') { |memodb| JSON.dump(memo_params, memodb) }
end

def memos?(memos, params)
  if memos.nil? || memos['memos'][0].nil?
    memos = { 'memos': [params.merge!('id': 1)] }
  else
    memos['memos'] << params.merge!('id': memos['memos'][-1]['id'].to_i + 1)
  end
  memos
end

get '/' do
  memos = import_json
  @memo_info = memos
  erb :top
end

get '/new_memo' do
  erb :new_memo
end

post '/adds' do
  params.transform_values! { |params_value| h(params_value) }
  export_json(memos?(memos, params))
  redirect '/'
end

get '/memo/:id' do
  memo_info = memos['memos'][fetch_memo(memos, params)]

  @memo_id = memo_info['id']
  @memo_title = memo_info['title']
  @memo_context = memo_info['text']

  erb :memo_contexts
end

get '/memo/:id/context' do
  memo_info = memos['memos'][fetch_memo(memos, params)]

  @memo_id = memo_info['id']
  @memo_title = memo_info['title']
  @memo_context = memo_info['text']
  erb :memo_contexts_edit
end

patch '/memo/:id/context' do
  params.transform_values! { |params_value| h(params_value) }
  export_json(update_memo(memos, params))

  redirect '/'
end

delete '/memo/:id' do
  memos['memos'].delete_at(fetch_memo(memos, params))
  export_json(memos)

  redirect '/'
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

not_found do
  "404 Not Found. You requested a route that wasn't available."
end
