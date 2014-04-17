require 'sinatra'

get '/' do
	erb :network
	
end

get '/clusters' do
	erb :clusters
end

get '/TOM' do 
	erb :rank
end

get '/network' do
	erb :network
end