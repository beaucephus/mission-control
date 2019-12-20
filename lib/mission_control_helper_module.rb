#
# Helpers for Mission Control game.
#
module MissionControlHelper
  #
  # Prompt user for affirmation and return boolean value.
  #
  def affirm_prompt
    loop do
      case gets.chomp
      when /y|Y/
        return true
      when /n|N/
        return false
      else
        puts "Please respond (y/n):"
        next
      end
    end
  end

  #
  # "Fudges" a numerical mission statistic.
  # Returns a value within 20% above or below the supplied value.
  #
  def fudge(stat)
    stat * rand(0.8..1.2)
  end

  #
  # Formats a nyumberical mission statistic for pretty printing.
  # Rounds floats to second decimal place.
  # Inserts commas.
  #
  def format_stat(stat)
    # Round, convert to string, and split by the decimal.
    parts = stat.round(2).to_s.split(".")

    parts[0] = parts[0].reverse.scan(/\d{3}|.+/).join(",").reverse # Add commas.

    parts.join(".") # Join by the decimal.
  end
end
