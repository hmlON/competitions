class Ride < Struct.new(:id, :start_x, :start_y, :end_x,:end_y, :earliest_start, :lastest_finish)
  attr_accessor :status

  def initialize(*args)
    super(*args)
    @status = :pending
  end

  def duration
    (start_x - end_x).abs + (start_y - end_y).abs
  end

  def distance_to(car)
    (start_x - car.x).abs + (start_y - car.y).abs
  end

  def pending?
    status == :pending
  end

  def active?
    status == :active
  end

  def finished?
    status == :finished
  end
end

class Car
  attr_accessor :x, :y, :rides, :free, :counter

  def initialize
    @x = 0
    @y = 0
    @rides = []
    @free = true
  end

  def free?
    free
  end

  def add_ride(ride, wait_time)
    rides << ride
    @x = ride.end_x
    @y = ride.end_y
    @free = false
    ride.status = :active
    @counter = wait_time + ride.distance_to(self) + ride.duration
  end

  def to_s
    "Car: (#{x}, #{y}), rides: [#{rides.map(&:id).join(", ")}]"
  end
end

in_filename = 'e_high_bonus.in'
out_filename = 'e.out'

f = File.open(in_filename, "r")
row, col, cars_count, rides_count, es_bonus, steps_count = f.readline.split(' ').map(&:to_i)

rides = f.each_line.map.with_index do |ride_info, i|
  Ride.new(i, *ride_info.split(' ').map(&:to_i))
end
f.close
cars = Array.new(cars_count) { Car.new }

# puts rides#.map &:pending?
# puts cars#.map &:duration

# puts rides.map {|ride| ride.distance_to(cars.first)}




# steps_count.times do |t|
  # puts "Time: #{t}"
t = 0
a = rides.select(&:pending?).map do |ride|
  cars.select(&:free?).map do |car|
    ride.earliest_start - t - ride.distance_to(car)
  end
end

max = a.map { |a| a.max }.max
# cars.select(&:free?).map do |car|
puts max
  rides.select(&:pending?).map do |ride|
    cars.select(&:free?).map do |car|
      if ride.earliest_start - t - ride.distance_to(car) == max
        wait_time = max > 0 ? max : 0
        car.add_ride(ride, wait_time)
        break
      end
    end
  end
end

# r = rides.select(&:pending?)
# c = cars.select(&:free?)

# c.map do |car|
# end
# a = r.map do |ride|
#     ride.earliest_start - t - ride.distance_to(car)
# end





# steps_count.times do |t|
#   puts "Time: #{t}"
#   cars.each do |car|
#     if car.counter&.> 0
#       car.counter -= 1
#     end

#     if car.counter == 0
#       car.free = true
#     end
#     # puts car
#   end

#   # cars.select(&:free?).each do |meta_car|
#   # cat_count.times do
#   r = rides.select(&:pending?)
#   c = cars.select(&:free?)

#   a = r.map do |ride|
#     c.map do |car|
#       ride.earliest_start - t - ride.distance_to(car)
#     end
#   end
#   # p a
#   max = a.map { |a| a.max }.max
#     # puts max
#   # rides.select(&:pending?).map do |ride|
#   #   cars.select(&:free?).map do |car|
#   #     if ride.earliest_start - t - ride.distance_to(car) == max
#   #       wait_time = max > 0 ? max : 0
#   #       car.add_ride(ride, wait_time)
#   #       break
#   #     end
#   #   end
#   # end

#   # cars.select(&:free?).each do |meta_car|
#   #   a = rides.select(&:pending?).map do |ride|
#   #     cars.select(&:free?).map do |car|
#   #       ride.earliest_start - t - ride.distance_to(car)
#   #     end
#   #   end
#   #   # p a
#   #   max = a.map { |a| a.max }.max
#   #   # puts max
#   #   rides.select(&:pending?).map do |ride|
#   #     cars.select(&:free?).map do |car|
#   #       if ride.earliest_start - t - ride.distance_to(car) == max
#   #         wait_time = max > 0 ? max : 0
#   #         car.add_ride(ride, wait_time)
#   #         break
#   #       end
#   #     end
#   #   end
#   # end
# end

s = cars.map {|car| car.rides.map(&:id)}.map do |rides|
  "#{rides.count} #{rides.join(' ')}"
end.join("\n")
# puts s

f = File.new(out_filename, "w")
f.write(s)
