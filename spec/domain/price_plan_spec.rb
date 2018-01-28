require 'rspec'
require 'date'
require_relative '../../lib/domain/price_plan'

describe PricePlan do

  it 'should return the base price given an ordinary date time' do
    peak_time_multiplier = PricePlan::PeakTimeMultiplier.new 3, 10.0  # multiply by 10 on Wednesdays
    price_plan = PricePlan.new nil, nil, 1.0, [peak_time_multiplier]

    normal_date_time = DateTime.new 2018, 1, 28, 0, 0, 0
    expect(price_plan.price(normal_date_time)).to eq(1.0)
  end

  it 'should return exception price given exceptional date time' do
    peak_time_multiplier = PricePlan::PeakTimeMultiplier.new 0, 10.0  # multiply by 10 on Sundays
    price_plan = PricePlan.new nil, nil, 1.0, [peak_time_multiplier]

    normal_date_time = DateTime.new 2018, 1, 28, 0, 0, 0
    expect(price_plan.price(normal_date_time)).to eq(10.0)
  end

end