ENV['RACK_ENV'] = 'test'

require_relative '../../lib/controller/meter_reading_controller.rb'
require 'json'
require 'rspec'
require 'rack/test'

describe MeterReadingController do
  include Rack::Test::Methods

  let(:app) { described_class.new(electricity_reading_service) }
  let(:electricity_reading_service) { ElectricityReadingService.new }
  
  describe '/readings/store' do

    it 'should store a meter reading against a new meter' do
      readings_record = {
        'smartMeterId' => '0101010',
        'electricityReadings' => [
          { 'time': '2018-01-01T00:00:00.000Z', 'reading': 1.5 },
          { 'time': '2018-01-01T00:00:00.000Z', 'reading': 1.5 }
        ]
      }
      post '/readings/store', readings_record.to_json, 'CONTENT_TYPE' => 'application/json'
      expect(last_response).to be_ok

      get '/readings/read/0101010'
      expect(JSON.parse(last_response.body).length).to eq 2
    end
    
    it 'should return error response when no meter id is supplied' do
      post '/readings/store', {}.to_json, 'CONTENT_TYPE' => 'application/json'
      expect(last_response.status).to eq 500
    end

    it 'should return error response when given empty readings' do
      post '/readings/store', { 'smartMeterId' => '0101010', 'electricityReadings' => [] }.to_json, 'CONTENT_TYPE' => 'application/json'
      expect(last_response.status).to eq 500
    end

    it 'should return error response when readings not provided' do
      post '/readings/store', { 'smartMeterId' => '0101010' }.to_json, 'CONTENT_TYPE' => 'application/json'
      expect(last_response.status).to eq 500
    end
    
  end
  
end
