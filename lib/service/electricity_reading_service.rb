class ElectricityReadingService
    def initialize(readings_store = nil)
        @readings_store = readings_store || Hash.new
    end

    def getReadings(meter_id)
        if @readings_store.key?("smart-meter-2")
            @readings_store["smart-meter-2"]
          else
            []
        end
    end

    def storeReadings(meter_id, readings)
        @readings_store[meter_id] ||= []
        @readings_store[meter_id].concat(readings)
    end
end