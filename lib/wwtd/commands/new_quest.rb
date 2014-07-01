require 'ostruct'

module WWTD
  class NewQuest < Command
    def run(room, player_id)
      if room.start_new_quest
        qp = WWTD.db.create_quest_progress(quest_id: room.quest_id, player_id: player_id, room_id: room.id)
        return success :start_new_quest? => true, :quest_progress => qp
      else
        return success :start_new_quest? => false, :quest_progress => false
      end
    end
  end
end
