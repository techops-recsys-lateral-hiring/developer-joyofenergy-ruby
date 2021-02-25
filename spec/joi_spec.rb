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
    readings_record = {
      'smartMeterId' => 'smart-meter-0',
      'electricityReadings' => [
        { 'time': '2018-01-01T00:00:00.000Z', 'reading': 1.5 }
      ]
    }
    post '/readings/store', readings_record.to_json, 'CONTENT_TYPE' => 'application/json'

    get '/readings/read/smart-meter-0'

    expect(last_response).to be_ok
    expect(last_response['Content-type']).to include('json')
    expect(last_response.body).to include('reading')
  end
end
