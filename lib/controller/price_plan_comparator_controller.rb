class PricePlanComparatorController < Sinatra::Base
  def initialize(app = nil, price_plan_service, electricity_reading_service)
    super(app)
    @price_plan_service = price_plan_service
    @electricity_reading_service = electricity_reading_service
  end

  get '/price-plans/compare-all/{meter_id}' do
    content_type :json
    {
      'best-supplier' => 10.0,
      'second-best-supplier' => 20.0,
      'test-supplier' => 100.0
    }.to_json
  end

end