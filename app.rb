# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'rack/flash'
require './helpers/helpers'


configure do
  use Rack::Flash
end

enable :sessions

get '/' do
  import_json
  erb :top
end

get '/new_memo' do
  erb :new_memo
end

post '/new_memo' do
  if params['title'] == ''
    @message = 'タイトルが入力されていません。'
    @text = params['text']
    erb :new_memo
  else
    export_json(memos?(import_json, params.transform_values! { |key| h(key) }))
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
