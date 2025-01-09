require 'sinatra/base'
require_relative '../service/electricity_reading_service'

class MeterReadingController < Sinatra::Base
  def initialize(app = nil, electricity_reading_service)
    super(app)
    @electricity_reading_service = electricity_reading_service
  end

  before do
    if request.post? && request.content_length.to_i > 0
      request.body.rewind
      @request_payload = JSON.parse request.body.read
      auth_header = request.env['HTTP_AUTHORIZATION']
      puts auth_header
      if auth_header.nil?
        halt 401, 'Unauthorized: Missing or invalid Authorization header'
      end
    end
  end
  
  get '/readings/read/{meter_id}' do
    content_type :json
    @electricity_reading_service.getReadings(@params['meter_id']).to_json
  end

  post '/readings/store' do
    readings = @request_payload['electricityReadings']
    meter_id = @request_payload['smartMeterId']

    if !valid_meter_readings?(meter_id, readings)
      status 400
      return { error: "Invalid smartMeterId or empty readings" }.to_json
    end

    @electricity_reading_service.storeReadings(meter_id, readings)
    status 200
    {}.to_json
  end

  private

  def valid_meter_readings?(meter_id, readings)
    meter_id.nil? && !meter_id.empty? && readings && readings.length > 0
  end
end
