require 'ostruct'

module WWTD
  class EnterLivingRoom < Command
    include ManipulateQuestProgress
    def run(player, room)
      qp_data = get_quest_data(player.id, room.quest_id)
      entered_before = qp_data["entered_living_room"]
      zombie_dead = qp_data['killed_first_zombie']
      if entered_before && zombie_dead
        return success :message => room.name
      end

      WWTD.db.change_qp_data(player.id, 1, entered_living_room: true)
      first_action = qp_data["first_completed_action"]
      if first_action != 'use phone'
        # attacking_zombie = AsciiArt.new("./lib/assets/attacking_zombie.jpg")
        # puts attacking_zombie.to_ascii_art
        puts "OH NO! You thought the cure worked.".white.on_red
        puts "But nope. It didn't, and zombies are back. Unfortunately, one just crashed through the window and attacked, killing you.".white.on_red
        puts "Maybe you should have answered that phone call...".white.on_red
        WWTD.db.update_player(player.id, dead: true)
        return success :message => "GAME OVER"
      else
        # attacking_zombie = AsciiArt.new("./lib/assets/attacking_zombie.jpg")
        # puts attacking_zombie.to_ascii_art
        zombie = WWTD.db.get_character_by_name("First Zombie")
        return success :message => zombie.description
      end
    end
  end
end

# if connection && new_room.name == "Player's Living Room" && entered_lr == false
      #   first_action = WWTD.db.get_quest_progress(player.id, new_room.quest_id).data["first_completed_action"]
      #   if first_action != 'answer phone'
      #     attacking_zombie = AsciiArt.new("./lib/assets/attacking_zombie.jpg")
      #     puts attacking_zombie.to_ascii_art
      #     puts "OH NO! You thought the cure worked.".white.on_light_blue
      #     puts "But nope. It didn't, and zombies are back. And one just crashed through the window, killing you.".white.on_light_blue
      #     return failure("GAME OVER")
      #   else
      #     WWTD.db.change_qp_data(player.id, new_room.quest_id, entered_living_room: true)
      #     new_player = WWTD.db.update_player(player.id, room_id: new_room.id)
      #     update_furthest_room(new_player, new_room)
      #     attacking_zombie = AsciiArt.new("./lib/assets/attacking_zombie.jpg")
      #     puts attacking_zombie.to_ascii_art
      #     zombie = WWTD.db.get_character_by_name("First Zombie")
      #     return success :message => zombie.description, :player => new_player
      #   end
