require 'sinatra/base'
require 'json'

require_relative 'controller/meter_reading_controller'
require_relative 'controller/price_plan_comparator_controller'
require_relative 'service/electricty_reading_service'
require_relative 'service/price_plan_service'
require_relative 'service/account_service'
require_relative 'domain/price_plan'
require_relative 'generator/electricity_readings_generator'

DR_EVILS_DARK_ENERGY_ENERGY_SUPPLIER = "Dr Evil's Dark Energy";
THE_GREEN_ECO_ENERGY_SUPPLIER = "The Green Eco";
POWER_FOR_EVERYONE_ENERGY_SUPPLIER = "Power for Everyone";

MOST_EVIL_PRICE_PLAN_ID = "price-plan-0";
RENEWABLES_PRICE_PLAN_ID = "price-plan-1";
STANDARD_PRICE_PLAN_ID = "price-plan-2";

SARAHS_SMART_METER_ID = "meter-0";
PETERS_SMART_METER_ID = "meter-1";
CHARLIES_SMART_METER_ID = "meter-2";
ANDREAS_SMART_METER_ID = "meter-3";
ALEXS_SMART_METER_ID = "meter-4";

class JOIEnergy < Sinatra::Base
  price_plans = [
    PricePlan.new(MOST_EVIL_PRICE_PLAN_ID, DR_EVILS_DARK_ENERGY_ENERGY_SUPPLIER, 10.0, []),
    PricePlan.new(RENEWABLES_PRICE_PLAN_ID, THE_GREEN_ECO_ENERGY_SUPPLIER, 2.0, []),
    PricePlan.new(STANDARD_PRICE_PLAN_ID, POWER_FOR_EVERYONE_ENERGY_SUPPLIER, 1.0, []),
  ]
  smart_meter_to_price_plan_accounts = {
    SARAHS_SMART_METER_ID => MOST_EVIL_PRICE_PLAN_ID,
    PETERS_SMART_METER_ID => RENEWABLES_PRICE_PLAN_ID,
    CHARLIES_SMART_METER_ID => MOST_EVIL_PRICE_PLAN_ID,
    ANDREAS_SMART_METER_ID => STANDARD_PRICE_PLAN_ID,
    ALEXS_SMART_METER_ID => RENEWABLES_PRICE_PLAN_ID
  }
  reading_generator = ElectricityReadingsGenerator.new
  readings = Hash[smart_meter_to_price_plan_accounts.keys.collect {|meter_id| 
    [meter_id, reading_generator.generate(20)]
  }]

  electricity_reading_service = ElectricityReadingService.new(readings)
  price_plan_service = PricePlanService.new(price_plans, electricity_reading_service)
  account_service = AccountService.new smart_meter_to_price_plan_accounts

  use MeterReadingController, electricity_reading_service
  use PricePlanComparatorController, price_plan_service, account_service
end
