class ElectricityReadingService
    def initialize()
        @readings_store = Hash.new
    end

    def getReadings(meter_id)
        @readings_store[meter_id]
    end

    def storeReadings(meter_id, readings)
        @readings_store[meter_id] = readings
    end
end