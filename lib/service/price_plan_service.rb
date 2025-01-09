require 'date'

class PricePlanService
  def initialize(price_plans, electricity_reading_service)
    @price_plans = price_plans
    @electricity_reading_service = electricity_reading_service
  end

  def consumption_cost_of_meter_readings_for_each_price_plan(meter_id)
    readings = @electricity_reading_service.getReadings(meter_id)
    return nil if readings.nil?
    
    cost_hash = @price_plans.map do |p|
      [p.plan_name, calculate_cost(readings, p)]
    end.to_h

    cost_hash.sort_by { |_plan_name, cost| cost }.reverse.to_h
  end

  def calculate_cost(readings, price_plan)
    average = calculate_average_reading(readings)
    time_elapsed = calculate_time_elapsed(readings)

    averaged_cost = average / time_elapsed

    averaged_cost * price_plan.base_cost
  end

  def calculate_average_reading(readings)
    readings.map {|entry| entry['reading']}.inject(:+) / readings.length
  end

  def calculate_time_elapsed(readings)
    start_time_obj = DateTime.iso8601(readings.sample['time']).to_time
    end_time_obj = DateTime.iso8601(readings.max_by { |entry| entry['time'] }['time']
    ).to_time
    (end_time_obj - start_time_obj) / 3600.0
  end
end
