require 'ostruct'
require 'asciiart'

module WWTD
  class UsePhone < Command
    def run(player, input)
      current_room_id = player.room_id
      first_room = WWTD.db.get_first_room
      if current_room_id != first_room.id
        return failure("What call are you trying to answer? No one is calling you.")
      else
        first_action = WWTD.db.get_quest_progress(player.id, first_room.quest_id).data["first_completed_action"]
        if first_action != nil && (first_action != 'answer phone')
          return failure("Your phone is no longer ringing and there are no voicemails.")
        elsif first_action == 'answer phone'
          return success :message => 'Susie, is in trouble. Why are you trying to answer your phone again!?!'
        else
          WWTD.db.change_qp_data(player.id, first_room.quest_id, first_completed_action: 'answer phone')
          puts "(Panicked voice with sounds of yelling in the background) Hey. It's Susie.".white.on_light_blue
          puts "#{player.username}, I'm freaking out...you remember those patients who came in yesterday and the day before?".white.on_light_blue
          puts "The ones who were running really high fevers and unresponsive.".white.on_light_blue
          puts "(Sounds of yelling escalate with sounds of distinct moans in the background)".white.on_light_blue
          puts "THEY TURNED. There's a zombie outbreak in the hospital. I'm stuck in a patient's room we barricaded.".white.on_light_blue
          puts "They can't get in yet, bu--".white.on_light_blue
          return success :message => "(You hear a sound as the phone is dropped and then the line cuts off."
        end
      end
    end
  end
end
