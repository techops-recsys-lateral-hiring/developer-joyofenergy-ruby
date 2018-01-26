require 'sinatra/base'

class MeterReadingController < Sinatra::Base
  before do
    if request.body.length > 0
      request.body.rewind
      @request_payload = JSON.parse request.body.read
    end
  end
  
  get '/readings/read/{meter_id}' do
    content_type :json
    [{'reading' => 'cheese'}].to_json
  end

  post '/readings/store' do
    readings = @request_payload['electricityReadings']
    if readings && readings.length > 0
      status 200
    else
      status 500
    end
  end
end
