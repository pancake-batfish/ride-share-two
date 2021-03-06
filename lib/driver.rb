module RideShare

  class Driver
    attr_reader :id, :name, :vin

    def initialize(driver_hash)
      raise InvalidVINError.new("VIN must have 17 characters") if driver_hash[:vin].length != 17

      @id = driver_hash[:id]
      @name = driver_hash[:name]
      @vin = driver_hash[:vin]
    end

    def self.find(requested_id)
      # finds a specific instance of Driver based on driver ID
      match = Driver.all.select {|driver| driver.id == requested_id}
      return match[0]
    end

    def get_trips
      # returns collection of trips taken by this driver
      Trip.find_by_driver(id)
    end

    def avg_rating
      # calls get_trips; calculates average rating across all trips
      num_trips = get_trips.length.to_f
      ratings = get_trips.map {|trip| trip.rating}

      begin
        ratings.reduce(:+)/num_trips
      rescue NoMethodError
        return nil
      end

    end

    private

    def self.all
      all_drivers = []
      driver_hash = {}

      CSV.foreach("support/drivers.csv", {:headers => true}) do |line|
          driver_hash[:id] = line[0].to_i
          driver_hash[:name] = line[1]
          driver_hash[:vin] = line[2]

          begin
            all_drivers << Driver.new(driver_hash)
          rescue InvalidVINError => e
            puts "Encountered an error: #{e.message}"
          end
      end
      return all_drivers
    end

  end

end
