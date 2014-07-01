require 'ostruct'

module WWTD
  class NewQuest < Command
    def run(room)
      if room.start_new_quest
        return success :start_new_quest? => true
      else
        return success :start_new_quest? => false
      end
    end
  end
end
