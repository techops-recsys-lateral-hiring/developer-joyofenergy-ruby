class PricePlanComparatorController < Sinatra::Base
  def initialize(app = nil, price_plan_service, electricity_reading_service)
    super(app)
    @price_plan_service = price_plan_service
    @electricity_reading_service = electricity_reading_service
  end

  get '/price-plans/compare-all/{meter_id}' do
    content_type :json
    meter_id = @params[:meter_id]
    @price_plan_service.consumption_cost_of_meter_readings_for_each_price_plan(meter_id).to_json
  end

  get '/price-plans/recommend/{meter_id}' do
    content_type :json
    meter_id = @params[:meter_id]
    price_plan_comparisons = @price_plan_service.consumption_cost_of_meter_readings_for_each_price_plan(meter_id)

    price_plan_comparisons.to_a.sort {|a, b| a[1] <=> b[1]}.map {|x| {x[0] => x[1]}}.to_json
  end
end