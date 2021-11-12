# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'rack/flash'

enable :sessions

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

get '/' do
  import_json
  erb :top
end

get '/new_memo' do
  erb :new_memo
end

post '/new_memo' do
  if params['title'] == ''
    flash[:danger] = 'タイトルが入力されていません。'
    flash[:context] = params['text']
    redirect '/new_memo'
  else
    export_json(memos?(import_json, params))
    redirect '/'
  end
end

get '/memo/:id' do
  fetch_memo(import_json, params)
  erb :memo_contexts
end

get '/memo/:id/context' do
  fetch_memo(import_json, params)
  erb :memo_contexts_edit
end

patch '/memo/:id/context' do
  if params['title'] == ''
    flash[:danger] = 'タイトルが入力されていません。'
    p params['text']
    fetch_memo(import_json, params)
    @memo['title'] = params['title']
    @memo['text'] = params['text']
    erb :memo_contexts_edit
  else
    update_memo(import_json, params)
    redirect '/'
  end
end

delete '/memo/:id' do
  memos = import_json
  memos['memos'].delete_at(fetch_memo_number(memos, params))
  export_json(memos)
  redirect '/'
end

not_found do
  "404 Not Found. You requested a route that wasn't available."
end