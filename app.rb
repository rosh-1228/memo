# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

helpers do
  def h(param)
    Rack::Utils.escape_html(param)
  end

  def import_json
    @memos = JSON.load(File.open('json/memodb.json').read)
  end

  def fetch_memo_number(memos, memo_param)
    memos['memos'].find_index { |data| data['id'].to_i == memo_param['id'].to_i }
  end

  def fetch_memo(memos, params)
    @memo = memos['memos'][fetch_memo_number(memos, params)]
  end

  def export_json(params)
    params['memos'].each do |param|
      param.transform_keys! {|key| h(key)}
      param.transform_values! {|key| h(key)}
    end
    File.open('json/memodb.json', 'w') { |memodb| JSON.dump(params, memodb) }
  end
  
  def memos?(memos, params)
    if memos.nil? || memos['memos'][0].nil?
      memos = { 'memos'=>[params.merge!('id': 1)] }
    else
      memos['memos'] << params.merge!('id': memos['memos'][-1]['id'].to_i + 1)
    end
    memos
  end

  def update_memo(memos, memo_params)
    memo_params.delete('_method')
    memos['memos'][fetch_memo_number(memos, memo_params)].replace(memo_params)
    export_json(memos)
  end
end

get '/' do
  import_json
  erb :top
end

get '/new_memo' do
  erb :new_memo
end

post '/new_memo' do
  export_json(memos?(import_json, params))
  redirect '/'
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
  update_memo(import_json, params)
  redirect '/'
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
