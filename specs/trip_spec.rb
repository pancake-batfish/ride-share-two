require_relative './spec_helper'

describe "Trip initialize" do
  before do
    @trip_hash = {
      id: 5,
      driver_id: 3,
      rider_id: 12,
      date: "2015-12-14",
      rating: 2
    }

    @bad_rating_hash = {
      id: 5,
      driver_id: 3,
      rider_id: 12,
      date: "2015-12-14",
      rating: 6
    }
  end

  let(:trip) { RideShare::Trip.new(@trip_hash) }


  it "has required attributes" do
    trip.id.must_equal 5
    trip.driver_id.must_equal 3
    trip.rider_id.must_equal 12
    trip.date.must_equal "2015-12-14"
    trip.rating.must_equal 2
  end

  it "raises an error if rating is not in the range 1-5" do
    proc {
      RideShare::Trip.new(@bad_rating_hash)
    }.must_raise InvalidRatingError
  end
end

xdescribe "self.all" do
  let(:all_trips) { RideShare::Trip.all }

  it "creates an array of new Trip instances from a CSV file" do
    all_trips.must_be_instance_of Array
    all_trips.first.must_be_instance_of RideShare::Trip
    all_trips.last.must_be_instance_of RideShare::Trip
  end

  it "creates new Trips that match the trip ID and driver ID of first/last lines in file" do
    all_trips.first.id.must_equal 1
    all_trips.first.driver_id.must_equal 1
    all_trips.last.id.must_equal 600
    all_trips.last.driver_id.must_equal 61
  end

end

xdescribe "self.find_by_driver" do
  let(:driver_trips) {RideShare::Trip.find_by_driver(99)}

  it "returns an array of Trip instances" do
    driver_trips.must_be_instance_of Array
    driver_trips[0].must_be_instance_of Trip
  end

  it "correctly finds the trips for a given driver" do
    driver_trips.length.must_equal 6
    valid_trip_ids = [54, 86, 230, 420, 423, 531]
    driver_trips.each do |trip|
      verify_id = valid_trip_ids.include?(trip.id)
      verify_id.must_equal true
    end
  end

  it "raises an error for a driver ID that doesn't exist" do
    proc { RideShare::Trip.find_by_driver(999)}.must_raise ArgumentError
  end

end

describe "self.find_by_rider" do

end

describe "get_driver" do

end

describe "get_rider" do

end
