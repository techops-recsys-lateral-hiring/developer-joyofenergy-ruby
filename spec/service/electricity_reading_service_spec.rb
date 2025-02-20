require_relative '../../lib/service/electricty_reading_service.rb'
require 'rspec'
describe ElectricityReadingService do
  it "should return null when asked for a meter that doesn't exist" do
    meter_reading_service = ElectricityReadingService.new
    expect(meter_reading_service.getReadings('nonexistent-meter')).to be_nil
  end
  it "should return meter readings for a meter that exists" do
    meter_reading_service = ElectricityReadingService.new
    meter_reading_service.storeReadings('meter-id', [])
    expect(meter_reading_service.getReadings('meter-id')).to eq []
  end
  it "should store more meter readings against an existing meter" do
    meter_reading_service = ElectricityReadingService.new
    meter_reading_service.storeReadings('meter-id', ['reading 1'])
    meter_reading_service.storeReadings('meter-id', ['reading 2'])
    expect(meter_reading_service.getReadings('meter-id')).to eq ['reading 1', 'reading 2']
  end
end