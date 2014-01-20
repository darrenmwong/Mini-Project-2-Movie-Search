require 'sinatra'
require 'sinatra/reloader'
require 'typhoeus'
require 'json'

get "/" do
	erb :index
end

post '/result' do
  search_str = params[:movie]
  response = Typhoeus.get("www.omdbapi.com/", :params => {:s => search_str})
  @result = JSON.parse(response.body)
  erb :result
end



get '/poster/:imdb' do |imdb_id|
  key = Typhoeus.get("www.omdbapi.com", :params => {:i => "#{imdb_id}"})
  @poster_id = JSON.parse(key.body)
  erb :poster

end
