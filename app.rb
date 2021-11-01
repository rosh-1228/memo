require 'sinatra'
require 'sinatra/reloader'
require 'json'

class Memo
  def initialize
    @memo_info = File.open("json/memodb.json") do |memo|
      JSON.load(memo)
    end
  end

  def io_memodb
    @memo_info
  end
end

get '/' do
  @memo_info = Memo.new.io_memodb
  erb :top
end

get '/new_memo' do
  erb :new_memo
end

post '/adds' do
  memo_info = Memo.new.io_memodb

  if memo_info.nil?
    memo_info = {"memos": [params.merge!("id": 1)]}
  else
    params.merge!("id": memo_info["memos"][-1]["id"].to_i + 1)
    memo_info["memos"] << params
  end

  File.open("json/memodb.json", "w") do |memodb|
    JSON.dump(memo_info, memodb)
  end
  redirect '/'
end

get '/memo/:id' do
  memo_memo = Memo.new.io_memodb

  memo_info = JSON.parse(memo_memo.to_json, {symbolize_names: true})
  memo_elm = memo_info[:memos].find {|data| data[:id].to_i == params[:id].to_i }

  number = memo_info[:memos].index(memo_elm)
  memo = memo_memo["memos"][number]
  @memo_id = memo["id"]
  @memo_title = memo["title"]
  @memo_context = memo["text"]
  erb :memo_contexts
end

get '/memo/:id/context' do
  memo_memo = Memo.new.io_memodb

  memo_info = JSON.parse(memo_memo.to_json, {symbolize_names: true})
  memo_elm = memo_info[:memos].find {|data| data[:id].to_i == params[:id].to_i }

  number = memo_info[:memos].index(memo_elm)
  memo = memo_memo["memos"][number]
  @memo_id = memo["id"]
  @memo_title = memo["title"]
  @memo_context = memo["text"]
  erb :memo_contexts_edit
end

patch '/memo/:id/context' do
  memo_memo = Memo.new.io_memodb

  memo_info = JSON.parse(memo_memo.to_json, {symbolize_names: true})
  memo_elm = memo_info[:memos].find {|data| data[:id].to_i == params[:id].to_i }

  number = memo_info[:memos].index(memo_elm)

  memo_memo["memos"][number]["title"] = params["title"]
  memo_memo["memos"][number]["text"] = params["text"]

  File.open("json/memodb.json", "w") do |memodb|
    JSON.dump(memo_memo, memodb)
  end

  redirect "/"
end

delete '/memo/:id' do
  memo_memo = Memo.new.io_memodb
  memo_info = JSON.parse(memo_memo.to_json, {symbolize_names: true})
  memo_elm = memo_info[:memos].find {|data| data[:id].to_i == params[:id].to_i }

  number = memo_info[:memos].index(memo_elm)
  memo_memo["memos"].delete_at(number)

  File.open("json/memodb.json", "w") do |memodb|
    JSON.dump(memo_memo, memodb)
  end

  redirect "/"
end
