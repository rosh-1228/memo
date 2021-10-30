require 'sinatra'
require 'sinatra/reloader'
require 'json'

get '/' do
  File.open("json/memo.json") do |memo_title|
    @memo_memo = JSON.load(memo_title)
  end
  erb :top
end

get '/new_memo' do
  erb :new_memo
end

post '/adds' do
  json_data = open("json/memo.json") do |io|
    JSON.load(io)
  end

  if json_data.nil?
    json_data = {"memos" => [params.merge!("id" => "1")]}
  else
    params.merge!("id" => json_data["memos"][-1]["id"].to_i + 1)
    json_data["memos"] << params
  end

  File.open("json/memo.json", "w") do |file|
    JSON.dump(json_data, file)
  end
  redirect '/'
end

get '/:id/memo_list' do
  @m_title = open("json/memo.json") do |data|
    JSON.load(io)
  end
  puts json_data
  erb :memo_list
end

get '/id' do
  File.open("json/memo.json") do |memo_title|
    @memo_memo = JSON.load(memo_title)
  end
  puts @memo_memo["memos"]
end

patch '/id' do
  @edit_title
  @edit_text
end