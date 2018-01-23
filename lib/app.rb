require 'sinatra/base'
require 'json'

class JOIEnergy < Sinatra::Base
  get '/readings/read/smart-meter-0' do
    content_type :json
    { "reading" => "cheese" }.to_json
  end
end
