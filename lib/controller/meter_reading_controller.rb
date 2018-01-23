require 'sinatra/base'

class MeterReadingService

end

module Wiring
  def meter_reading_service
    @meter_reading_service ||= MeterReadingService.new
  end
end

class MeterReadingController < Sinatra::Base
  before do
    if request.body.length > 0
      request.body.rewind
      @request_payload = JSON.parse request.body.read
    end
  end
  
  get '/readings/read/smart-meter-0' do
    content_type :json
    { "reading" => "cheese" }.to_json
  end

  post '/readings/store' do
    readings = @request_payload['electricityReadings']
    if readings && readings.length > 0
      status 200
    else
      status 500
    end
  end

  include Wiring
end
