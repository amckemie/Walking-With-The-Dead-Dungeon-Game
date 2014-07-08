module WWTD
  class Fight < Command
    def run(player, opponent, shoot)
      fate = 0
      if shoot
        fate = 1 + rand(2)
      end

      if shoot && fate == 1
        return player_wins(player, opponent)
      elsif shoot
        return zombie_wins(player, opponent)
      end

      if player.strength > opponent.strength
        return player_wins(player, opponent)
      else
        return zombie_wins(player, opponent)
      end
    end

    def player_wins(player, opponent)
      new_strength = player.strength - opponent.strength
      WWTD.db.update_player(player.id, strength: new_strength)
      return success :message => "Whew! You killed the #{opponent.name}!", :deleted? => WWTD.db.delete_quest_character(player.id, opponent.id)
    end

    def zombie_wins(player, opponent)
      opponent.bite(player)
      return success :message => ('Oh nooossssssss! The zombie bit you! So sorry, but you are now infected.'), :player => player
    end
  end
end
