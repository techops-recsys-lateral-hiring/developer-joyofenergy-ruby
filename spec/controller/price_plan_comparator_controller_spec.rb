ENV['RACK_ENV'] = 'test'

require_relative '../../lib/controller/price_plan_comparator_controller.rb'
require_relative '../../lib/service/electricity_reading_service.rb'
require_relative '../../lib/service/price_plan_service.rb'
require_relative '../../lib/domain/price_plan'
require 'json'
require 'rspec'
require 'rack/test'

describe PricePlanComparatorController do
  include Rack::Test::Methods

  PRICE_PLAN_1_ID = 'test-supplier'
  PRICE_PLAN_2_ID = 'best-supplier'
  PRICE_PLAN_3_ID = 'second-best-supplier'

  let(:app) { described_class.new price_plan_service, account_service }
  let(:price_plan_service) { PricePlanService.new price_plans, electricity_reading_service }
  let(:electricity_reading_service) { ElectricityReadingService.new }
  let(:account_service) { AccountService.new 'meter-0' => PRICE_PLAN_1_ID }
  let(:price_plans) {[
    PricePlan.new(PRICE_PLAN_1_ID, nil, 10.0, nil),
    PricePlan.new(PRICE_PLAN_2_ID, nil, 1.0, nil),
    PricePlan.new(PRICE_PLAN_3_ID, nil, 2.0, nil)
  ]}
  
  describe '/price-plans/compare-all' do

    it 'should return 404 if there is no price plan associated with the meter' do
      get '/price-plans/compare-all/meter-1000'
      expect(last_response.status).to eq 404
    end

    it 'should get costs against all price plans' do
      readings = [
        { 'time' => '2018-01-01T00:00:00.000Z', 'reading' => 15.0 },
        { 'time' => '2018-01-01T01:00:00.000Z', 'reading' => 5.0 }
      ]
      electricity_reading_service.storeReadings('meter-0', readings)

      get '/price-plans/compare-all/meter-0'
      expect(last_response).to be_ok
      expect(JSON.parse(last_response.body)).to eq({
        PricePlanComparatorController::PRICE_PLAN_KEY => PRICE_PLAN_1_ID,
        PricePlanComparatorController::PRICE_PLAN_COMPARISON_KEY => {
          PRICE_PLAN_2_ID => 10.0,
          PRICE_PLAN_3_ID => 20.0,
          PRICE_PLAN_1_ID => 100.0
        }
      })
    end
    
  end
  
  describe '/price-plans/recommend' do

    it 'should return no match if there is no meter with that meter id' do
      get '/price-plans/recommend/meter-1000'
      expect(last_response.status).to eq(404)
    end

    it 'should recommend cheapest price plans for meter id without any limit' do
      readings = [
        { 'time' => '2018-01-01T00:00:00.000Z', 'reading' => 35.0 },
        { 'time' => '2018-01-01T00:30:00.000Z', 'reading' => 3.0 }
      ]
      electricity_reading_service.storeReadings('meter-0', readings)

      get '/price-plans/recommend/meter-0'
      expect(last_response).to be_ok
      expect(JSON.parse(last_response.body)).to eq([
        {PRICE_PLAN_2_ID => 38.0},
        {PRICE_PLAN_3_ID => 76.0},
        {PRICE_PLAN_1_ID => 380.0}
      ])
    end

    it 'should recommend cheapest price plans for meter id up to a limited number' do
      readings = [
        { 'time' => '2018-01-01T00:00:00.000Z', 'reading' => 35.0 },
        { 'time' => '2018-01-01T00:30:00.000Z', 'reading' => 3.0 }
      ]
      electricity_reading_service.storeReadings('meter-0', readings)

      get '/price-plans/recommend/meter-0?limit=2'
      expect(last_response).to be_ok
      expect(JSON.parse(last_response.body)).to eq([
        {PRICE_PLAN_2_ID => 38.0},
        {PRICE_PLAN_3_ID => 76.0},
      ])
    end

    it 'should recommend cheapest price plans for meter id, returning all if the limit is too big' do
      readings = [
        { 'time' => '2018-01-01T00:00:00.000Z', 'reading' => 35.0 },
        { 'time' => '2018-01-01T00:30:00.000Z', 'reading' => 3.0 }
      ]
      electricity_reading_service.storeReadings('meter-0', readings)

      get '/price-plans/recommend/meter-0?limit=5'
      expect(last_response).to be_ok
      expect(JSON.parse(last_response.body)).to eq([
        {PRICE_PLAN_2_ID => 38.0},
        {PRICE_PLAN_3_ID => 76.0},
        {PRICE_PLAN_1_ID => 380.0}
      ])
    end
  end

end
