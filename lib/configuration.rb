require_relative 'domain/price_plan'
require_relative 'generator/electricity_readings_generator'

module Configuration
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

  def price_plans
    [
      PricePlan.new(MOST_EVIL_PRICE_PLAN_ID, DR_EVILS_DARK_ENERGY_ENERGY_SUPPLIER, 10.0, []),
      PricePlan.new(RENEWABLES_PRICE_PLAN_ID, THE_GREEN_ECO_ENERGY_SUPPLIER, 2.0, []),
      PricePlan.new(STANDARD_PRICE_PLAN_ID, POWER_FOR_EVERYONE_ENERGY_SUPPLIER, 1.0, []),
    ]
  end

  def smart_meter_to_price_plan_accounts
    {
      SARAHS_SMART_METER_ID => MOST_EVIL_PRICE_PLAN_ID,
      PETERS_SMART_METER_ID => RENEWABLES_PRICE_PLAN_ID,
      CHARLIES_SMART_METER_ID => MOST_EVIL_PRICE_PLAN_ID,
      ANDREAS_SMART_METER_ID => STANDARD_PRICE_PLAN_ID,
      ALEXS_SMART_METER_ID => RENEWABLES_PRICE_PLAN_ID
    }
  end

  def readings
    reading_generator = ElectricityReadingsGenerator.new
    Hash[smart_meter_to_price_plan_accounts.keys.collect {|meter_id| 
      [meter_id, reading_generator.generate(20)]
    }]
  end
end