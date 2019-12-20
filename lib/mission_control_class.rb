require "./lib/mission_control_helper_module"
require "./lib/mission_class"

# The class that runs the Mission Control game.
class MissionControl
  include MissionControlHelper

  def initialize
    @session_travel_distance = 0
    @missions_aborted = 0
    @explosions = 0
    @session_fuel_burned = 0
    @session_flight_time = 0
  end

  #
  # Runs one session of Mission Control.
  #
  def run
    puts ""
    puts "Welcome to Mission Control!"
    mission_loop
    print_session_statistics
  end

  #
  # Private methods below.
  #
  private

  #
  # Executes missions until the player quits.
  #
  def mission_loop
    loop do
      puts ""
      puts "Please provide a name for the mission:"
      name = gets.chomp

      @mission = Mission.new(name)
      execute_mission

      puts ""
      puts "Would you like to initiate another mission? (y/n):"
      break unless affirm_prompt
    end
  end

  #
  # Runs mission execution and handles potential failures.
  #
  def execute_mission
    puts ""
    puts "Executing mission: #{@mission.name}."

    @mission.execute_launch_procedure
    update_session_statistics

    if @mission.exploded?
      explosion_protocol
    elsif @mission.aborted?
      mission_abort_protocol
    end
  end

  #
  # With catastrophic failure like an explosion,
  # there is nothing to do but move on to the next mission.
  #
  def explosion_protocol
    puts ""
    puts "The rocket exploded! Mission: #{@mission.name} failed."
  end

  #
  # Allow player the choice to retry an aborted mission.
  #
  def mission_abort_protocol
    puts ""
    puts "The launch was aborted!"
    puts ""
    puts "Would you like to retry mission: #{@mission.name}? (y/n):"

    if affirm_prompt
      @mission.reset
      execute_mission
    end
  end

  #
  # Gathers statistics from a mission to store in the session.
  #
  def update_session_statistics
    @session_travel_distance += @mission.travel_distance
    @missions_aborted += 1 if @mission.aborted?
    @explosions += 1 if @mission.exploded?
    @session_fuel_burned += @mission.fuel_burned
    @session_flight_time += @mission.flight_time
  end

  #
  # Prints totalled session statistics.
  #
  def print_session_statistics
    puts ""
    puts "Session statistics:"
    puts "  Distance traveled(km): #{format_stat(@session_travel_distance)}"
    puts "  Missions aborted:      #{format_stat(@missions_aborted)}"
    puts "  Explosions:            #{format_stat(@explosions)}"
    puts "  Fuel burned(liters)    #{format_stat(@session_fuel_burned)}"
    puts "  Flight time(m):        #{format_stat(@session_flight_time)}"
  end
end
