module WWTD
  class ActiveRecordDatabase
    def create_player(attrs)
      ar_player = Player.create!(attrs)
      build_player(ar_player)
    end

    def build_player(player)
      WWTD::PlayerNode.new(player)
    end

    def get_player(player_id)
      ar_player = Player.find_by(id: player_id)
      ar_player ? build_player(ar_player) : nil
    end

    def get_player_by_username(player_un)
      ar_player = Player.find_by(username: player_un)
      ar_player ? build_player(ar_player) : nil
    end

    def get_all_players
      players = Player.all
      players.map {|player| build_player(player)}
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
