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


def create_movies_table
  c = PGconn.new(:host => "localhost", :dbname => "movie")
  c.exec %q{
  CREATE TABLE movies (
    id SERIAL PRIMARY KEY,
    title TEXT,
    description TEXT,
    rating INTEGER
  );
  }
  c.close
end


get '/movies' do
  c = PGconn.new(:host => "localhost", :dbname => "movie")
  @movies = c.exec_params("SELECT * FROM movies;")
  c.close
  erb :movies
end

end
