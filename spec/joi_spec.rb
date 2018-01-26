ENV['RACK_ENV'] = 'test'

require_relative '../lib/app.rb'
require 'rspec'
require 'rack/test'

describe JOIEnergy do
  include Rack::Test::Methods

  def app
    JOIEnergy
  end
  
  it 'given a meter id, it should return readings' do
    get '/readings/read/meter-0'

    expect(last_response).to be_ok
    expect(last_response['Content-type']).to include('json')
    expect(last_response.body).to include('reading')
  end
end
