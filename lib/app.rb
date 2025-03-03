require 'sinatra/base'
require 'json'

require_relative 'controller/meter_reading_controller'
require_relative 'controller/price_plan_comparator_controller'
require_relative 'service/electricty_reading_service'
require_relative 'service/price_plan_service'
require_relative 'service/account_service'
require_relative './configuration'

class JOIEnergy < Sinatra::Base
  extend Configuration

  electricity_reading_service = ElectricityReadingService.new(readings)
  price_plan_service = PricePlanService.new(price_plans, electricity_reading_service)
  account_service = AccountService.new smart_meter_to_price_plan_accounts

  use MeterReadingController, electricity_reading_service
  use PricePlanComparatorController, price_plan_service, account_service
end
