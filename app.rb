require 'sinatra'

get '/' do
	erb :graph
end

get '/network' do
	erb :network
end