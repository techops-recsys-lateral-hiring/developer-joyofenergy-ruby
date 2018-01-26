require 'sinatra/base'
require 'json'

require_relative 'controller/meter_reading_controller'
require_relative 'service/electricty_reading_controller'

class JOIEnergy < Sinatra::Base
  use MeterReadingController, ElectricityReadingService.new
end
