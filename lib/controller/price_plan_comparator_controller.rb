class PricePlanComparatorController < Sinatra::Base
  PRICE_PLAN_KEY = 'pricePlanId'
  PRICE_PLAN_COMPARISON_KEY = 'pricePlanComparisons'

  def initialize(app = nil, price_plan_service, account_service)
    super(app)
    @price_plan_service = price_plan_service
    @account_service = account_service
  end

  get '/price-plans/compare-all/{meter_id}' do
    content_type :json
    meter_id = @params[:meter_id]
    price_plan = @account_service.price_plan_for_meter(meter_id)
    if price_plan.nil?
      status 404
    end
    comparisons = @price_plan_service.consumption_cost_of_meter_readings_for_each_price_plan(meter_id)
    if comparisons.nil?
      status 404
    else
      {
        PRICE_PLAN_KEY => price_plan,
        PRICE_PLAN_COMPARISON_KEY => comparisons
      }.to_json
    end
  end

  get '/price-plans/recommend/{meter_id}' do
    content_type :json
    meter_id = @params[:meter_id]
    limit = @params[:limit]

    price_plan_comparisons = @price_plan_service.consumption_cost_of_meter_readings_for_each_price_plan(meter_id)
    ordered_price_plans = price_plan_comparisons.to_a.sort {|a, b| a[1] <=> b[1]}.map {|x| {x[0] => x[1]}}

    if ordered_price_plans.empty?
      status 404
    elsif limit.nil?
      ordered_price_plans.to_json
    else
      ordered_price_plans.first(limit.to_i).to_json
    end
  end
end