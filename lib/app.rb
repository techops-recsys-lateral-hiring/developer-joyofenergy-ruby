require 'sinatra/base'
require 'json'

require_relative 'controller/meter_reading_controller'
require_relative 'controller/price_plan_comparator_controller'
require_relative 'service/electricty_reading_service'
require_relative 'service/price_plan_service'

class JOIEnergy < Sinatra::Base
  electricity_reading_service = ElectricityReadingService.new
  use MeterReadingController, electricity_reading_service
  use PricePlanComparatorController, PricePlanService.new([]), electricity_reading_service
end
