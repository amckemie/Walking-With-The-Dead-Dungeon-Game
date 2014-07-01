require 'ostruct'

module WWTD
  class NewQuest < Command
    def run(room)
      if room.start_new_quest
        return success
      else
        return failure
      end
    end
  end
end
