require 'sinatra'
require 'sinatra/reloader'
require 'json'

def import_json
  File.open("json/memodb.json") do |memo|
    JSON.load(memo)
  end
end

def take_number_from_array(id)
  memo_hash = JSON.parse(import_json.to_json, {symbolize_names: true})
  memo_elm = memo_hash[:memos].find {|data| data[:id].to_i == id.to_i }
  number = memo_hash[:memos].index(memo_elm)
end

def take_memo_from_hash(id)
  import_json["memos"][take_number_from_array(id)]
end

def update_hash(memo_params)
  memo_params.delete("_method")
  export_json = import_json
  array_number = take_number_from_array(memo_params["id"])
  memo_params = memo_params.to_h
  export_json["memos"][array_number].replace(memo_params)
  export_json
end

def export_json(memo_params)
  File.open("json/memodb.json", "w") do |memodb|
    JSON.dump(memo_params, memodb)
  end
end


get '/' do
  @memo_info = import_json
  erb :top
end

get '/new_memo' do
  erb :new_memo
end

post '/adds' do
  memo_info = import_json

  if memo_info.nil? || memo_info["memos"][0].nil?
    memo_info = {"memos": [params.merge!("id": 1)]}
  else
    params.merge!("id": memo_info["memos"][-1]["id"].to_i + 1)
    memo_info["memos"] << params
  end

  export_json(memo_info)

  redirect '/'
end

get '/memo/:id' do

  memo = take_memo_from_hash(params["id"])

  @memo_id = memo["id"]
  @memo_title = memo["title"]
  @memo_context = memo["text"]

  erb :memo_contexts
end

get '/memo/:id/context' do
  memo = take_memo_from_hash(params["id"])

  @memo_id = memo["id"]
  @memo_title = memo["title"]
  @memo_context = memo["text"]
  erb :memo_contexts_edit
end

patch '/memo/:id/context' do
  
  export_json(update_hash(params))

  redirect "/"
end

delete '/memo/:id' do

  memo_info = import_json
  memo_info["memos"].delete_at(take_number_from_array(params[:id]))
  export_json(memo_info)

  redirect "/"
end
