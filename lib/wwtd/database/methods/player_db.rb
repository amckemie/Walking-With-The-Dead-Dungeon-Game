module WWTD
  class ActiveRecordDatabase
    def create_player(attrs)
      ar_player = Player.create!(attrs)
      build_player(ar_player)
    end

    def build_player(player)
      WWTD::PlayerNode.new(id: player.id,
        username: player.username,
        password: player.password,
        description: player.description,
        strength: player.strength,
        dead: player.dead,
        room_id: player.room_id
      )
    end

    def get_player(player_id)
      ar_player = Player.find(player_id)
      build_player(ar_player)
    end

    def get_player_by_username(player_un)
      ar_player = Player.find_by(username: player_un)
      # binding.pry
      build_player(ar_player)
    end

    def get_all_players
      result = []
      players = Player.all
      players.each do |player|
        result << build_player(player)
      end
      result
    end

    def update_player(player_id, data)
      ar_player = Player.find(player_id)
      ar_player.update(data)
      build_player(ar_player)
    end

    def delete_player(player_id)
      ar_player = Player.find(player_id)
      ar_player.destroy
      return true if !Player.exists?(player_id)
    end
  end
end
