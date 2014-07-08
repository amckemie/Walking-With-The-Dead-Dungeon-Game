module WWTD
  class Fight < Command
    def run(player, room)
      chars = WWTD.db.get_zombie_characters(player.id, room.id)
      if chars.nil?
        return failure("Save your energy. There's no (more) zombie(s) to fight here.")
      else
        return fight_opponent(player, chars[0], false, room)
      end
    end

    def fight_opponent(player, opponent, shoot, room)
      fate = 0
      if shoot
        fate = 1 + rand(2)
      end

      if shoot && fate == 1
        return player_wins(player, opponent, room)
      elsif shoot
        return zombie_wins(player, opponent)
      end

      if player.strength > opponent.strength
        return player_wins(player, opponent, room)
      else
        return zombie_wins(player, opponent)
      end
    end

    def player_wins(player, opponent, room)
      new_strength = player.strength - opponent.strength
      WWTD.db.update_player(player.id, strength: new_strength)
      update_room_for_player(player, room)
      return success :message => "Whew! You killed the #{opponent.name}!", :deleted? => WWTD.db.delete_quest_character(player.id, opponent.id), :player => player
    end

    def zombie_wins(player, opponent)
      opponent.bite(player)
      return success :message => ('Oh nooossssssss! The zombie bit you! So sorry, but you are now infected.'), :player => player
    end

    def update_room_for_player(player, room)
      if room.name == "Player's Living Room"
        WWTD.db.change_qp_data(player.id, room.quest_id, killed_first_zombie: true)
        WWTD.db.update_player_room(player.id, room.id, description: "Blood splatters the walls. The zombie you killed lays half on the couch and half on the floor. There is a backpack in the corner and a tv, which is off currently, on the wall.")
      end
    end
  end
end
