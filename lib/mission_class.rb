require "./lib/mission_control_helper_module"

# Class representing a single mission.
class Mission
  include MissionControlHelper

  TRAVEL_DISTANCE_GOAL = 160.0 # kilometers
  PAYLOAD_CAPACITY = 50_000.0 # kilograms
  FUEL_CAPACITY = 1_514_100.0 # liters
  ESTIMATED_BURN_RATE = 168_233.0 # liters/minute
  ESTIMATED_AVERAGE_SPEED = 1500.0 # kilometers/hour

  # Time is distance / speed.
  # Multiply by 60 to convert hours to minutes.
  ESTIMATED_FLIGHT_TIME = TRAVEL_DISTANCE_GOAL / ESTIMATED_AVERAGE_SPEED \
    * 60.0 # minutes

  attr_accessor :name, :flight_time, :fuel_burned, :travel_distance

  def initialize(name)
    @name = name
    reset
    print_mission_plan
  end

  #
  # Performs the launch procedure dialog and launches the rocket.
  # Any negative response from the player triggers a mission abort.
  #
  def execute_launch_procedure
    puts ""
    [
      "Enable stage 1 afterburner? (y/n):",
      "Disengage release structure? (y/n):",
      "Perform cross-checks? (y/n):",
      "Go for Launch? (y/n):"
    ].each do |query|
      puts query
      unless affirm_prompt
        @aborted = true
        return nil # Return value is not important here.
      end
    end

    check_for_abort
    check_for_explosion

    launch unless aborted? || exploded?
  end

  def aborted?
    @aborted
  end

  def exploded?
    @exploded
  end

  def reset
    @flight_time = 0.0 # minutes
    @travel_distance = 0.0 # kilometers
    @fuel_burned = 0.0 # liters
    @aborted = false
    @exploded = false
  end

  #
  # Private methods below.
  #
  private

  #
  # Returns a "fudged" burn rate based on the estimated rate.
  #
  def burn_rate
    fudge(ESTIMATED_BURN_RATE)
  end

  #
  # Returns a "fudged" average speed based on the estimated speed.
  #
  def average_speed
    # Speed function should read 0 if 0 flight time.
    return 0 if @flight_time.zero?

    fudge(ESTIMATED_AVERAGE_SPEED)
  end

  #
  # Trigger an abort on 33% of launches.
  #
  def check_for_abort
    @aborted = true if rand < 0.33
  end

  #
  # Trigger an explosion on 20% of launches.
  #
  def check_for_explosion
    if rand < 0.20
      @exploded = true

      # Set the flight time to some reasonable value to simulate explosion
      # mid-flight.
      @flight_time = rand(1..ESTIMATED_FLIGHT_TIME)
    end
  end

  #
  # Simulates a successful launch.
  #
  def launch
    puts ""
    puts "Launched! #{@name} is away, en route to low earth orbit."

    while @travel_distance < TRAVEL_DISTANCE_GOAL
      fly_rocket
      print_statistics
    end

    puts ""
    puts "Mission Success! #{@name} has safely arrived in low earth orbit."
  end

  #
  # Simulates flying a rocket by incrementing time and updating resultant
  # distance travelled and fuel burned.
  #
  def fly_rocket
    time_increment = 1.0

    @flight_time += time_increment

    # Convert speed to km/m before calculating travel distance.
    speed_in_km_per_m = average_speed / 60.0
    @travel_distance += speed_in_km_per_m * time_increment

    @fuel_burned += burn_rate * time_increment

    # Delay the prompt one second for each increment of simulated flight.
    sleep 1
  end

  def print_statistics
    puts ""
    puts "Mission Statistics:"
    puts "  Distance traveled(km): #{format_stat(@travel_distance)}"
    puts "  Average speed(km/h):   #{format_stat(average_speed)}"
    puts "  Fuel burned(liters):   #{format_stat(@fuel_burned)}"
    puts "  Flight time(m):        #{format_stat(@flight_time)}"
  end

  def print_mission_plan
    puts ""
    puts "Mission plan:"
    puts "  Distance to goal(km):     #{format_stat(TRAVEL_DISTANCE_GOAL)}"
    puts "  Payload capacity(kg):     #{format_stat(PAYLOAD_CAPACITY)}"
    puts "  Fuel capacity(liters):    #{format_stat(FUEL_CAPACITY)}"
    puts "  Estimated burn rate(l/m): #{format_stat(ESTIMATED_BURN_RATE)}"
    puts "  Average speed(kl/h):      #{format_stat(ESTIMATED_AVERAGE_SPEED)}"
    puts "  Estimated flight time(m): #{format_stat(ESTIMATED_FLIGHT_TIME)}"
  end
end
