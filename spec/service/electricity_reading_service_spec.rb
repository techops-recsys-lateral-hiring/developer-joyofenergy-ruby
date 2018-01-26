require_relative '../../lib/service/electricty_reading_controller.rb'
require 'rspec'

describe ElectricityReadingService do

    it "should return null when asked for a meter that doesn't exist" do
        meter_reading_service = ElectricityReadingService.new
        expect(meter_reading_service.getReadings('nonexistent-meter')).to be_nil
    end

end