require 'sinatra/base'
require 'json'

require_relative 'controller/meter_reading_controller'

class JOIEnergy < Sinatra::Base
  use MeterReadingController
end
