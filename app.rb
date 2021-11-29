# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'rack/flash'
require './helpers/edit_data_helpers'
require './helpers/search_helpers'

configure do
  use Rack::Flash
end

enable :sessions

get '/' do
  import_json
  erb :top
end

get '/memos/new' do
  flash[:danger] = ''
  @memo = {'text' => ''}
  erb :new_memo
end

post '/memos' do
  if params['title'] == ''
    flash[:danger] = 'タイトルが入力されていません。'
    @memo = {'text' => params['text']}
    erb :new_memo
  else
    export_json(memos?(import_json, params))
    redirect '/'
  end
end

get '/memos/:id' do
  fetch_memo(import_json, params)
  erb :memo_contexts
end

get '/memos/:id/edit' do
  fetch_memo(import_json, params)
  erb :memo_contexts_edit
end

patch '/memos/:id/edit' do
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

delete '/memos/:id' do
  memos = import_json
  memos['memos'].delete_at(fetch_memo_number(memos, params))
  export_json(memos)
  redirect '/'
end

not_found do
  "404 Not Found. You requested a route that wasn't available."
end
