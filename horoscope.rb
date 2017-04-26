require 'dotenv'
Dotenv.load
require 'httparty'
require 'oauth'
require 'sinatra'

get '/' do
  articles = HTTParty.get("https://en.wikipedia.org/w/api.php?action=query&list=random&rnlimit=5&rnnamespace=0&format=json")
  @prediction = "You will have a day full of #{articles["query"]["random"].first["title"]}"
  erb :index
end

get '/pow' do
  '💥'
end

post '/tweet' do
  consumer = OAuth::Consumer.new(
    ENV['API_KEY'], ENV['API_SECRET'],
    { site: 'https://api.twitter.com', scheme: 'header' }
  )
  token_hash = { oauth_token: ENV['ACCESS_TOKEN'], oauth_token_secret: ENV['ACCESS_TOKEN_SECRET'] }
  access_token = OAuth::AccessToken.from_hash(consumer, token_hash)
  access_token.request(:post, '/1.1/statuses/update.json', status: params[:status_text])

  redirect to('/pow')
end
