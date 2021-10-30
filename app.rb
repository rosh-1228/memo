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
    memo_info = {"memos" => [params.merge!("id" => "1")]}
  else
    params.merge!("id" => memo_info["memos"][-1]["id"].to_i + 1)
    memo_info["memos"] << params
  end

  File.open("json/memodb.json", "w") do |memodb|
    JSON.dump(memo_info, memodb)
  end
  redirect '/'
end

get '/memo/:id' do
  @memo_info = Memo.new.io_memodb
  erb :memo_contexts
end

get '/memo/:id/context' do
  memo_info = Memo.new.io_memodb["memos"][params[:id].to_i - 1]
  @memo_id = memo_info["id"]
  @memo_title = memo_info["title"]
  @memo_context = memo_info["text"]
  erb :memo_contexts_edit
end

patch '/memo/:id/context' do
=begin
  memo_info = Memo.new.io_memodb["memos"][params[:id].to_i - 1]
  ["title"] = params[:title]
  memo_info["text"] = params[:text]
  update_memo = Memo.new.io_memodb["memos"][params[:id].to_i - 1].merge!(memo_info)
  puts update_memo
=end
  memo_info = Memo.new.io_memodb
  memo_info["memos"][params[:id].to_i - 1]["title"] = params[:title]
  memo_info["memos"][params[:id].to_i - 1]["text"] = params[:text]
  File.open("json/memodb.json", "w") do |memodb|
    JSON.dump(memo_info, memodb)
  end
  redirect "/"
end
