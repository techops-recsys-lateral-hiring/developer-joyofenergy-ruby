require 'sinatra/base'
require 'json'

require_relative 'controller/meter_reading_controller'
require_relative 'controller/price_plan_comparator_controller'
require_relative 'service/electricty_reading_service'
require_relative 'service/price_plan_service'
require_relative 'service/account_service'

class JOIEnergy < Sinatra::Base
  electricity_reading_service = ElectricityReadingService.new
  price_plan_service = PricePlanService.new([], electricity_reading_service)
  account_service = AccountService.new Hash.new
  use MeterReadingController, electricity_reading_service
  use PricePlanComparatorController, price_plan_service, account_service
end
