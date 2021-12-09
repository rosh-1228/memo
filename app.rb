# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'rack/flash'
require 'pg'
require './helpers/helpers'
require './helpers/crud_helpers'
require 'pg/em'
require 'pg/em/connection_pool'


configure do
  use Rack::Flash
end

enable :sessions

get '/' do
  create_db
  load_memo
  erb :top
end

get '/memos/new' do
  flash[:danger] = ''
  @text = ''
  erb :new_memo
end

post '/memos' do
  if params['title'] == ''
    flash[:danger] = 'タイトルが入力されていません。'
    @text = params['text']
    erb :new_memo
  else
    add_memo(params)
    redirect '/'
  end
end

get '/memos/:id' do
  load_memo(params)
  erb :memo_contexts
end

get '/memos/:id/edit' do
  load_memo(params)
  erb :memo_contexts_edit
end

patch '/memos/:id' do
  if params['title'] == ''
    flash[:danger] = 'タイトルが入力されていません。'
    load_memo(params)
    @title = params['title']
    @text = params['text']
    erb :memo_contexts_edit
  else
    update_memo(params)
    redirect '/'
  end
end

delete '/memos/:id' do
  delete_memo(params['id'])
  redirect '/'
end

not_found do
  "404 Not Found. You requested a route that wasn't available."
end
