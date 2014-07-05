module WWTD
  class ActiveRecordDatabase
    # This table keeps track of individual player's rooms attributes and updates them accordingly

    def create_player_room(attrs)
      PlayerRoom.create!(attrs)
    end

    def get_player_room(player_id, room_id)
      PlayerRoom.where("player_id = ? AND room_id = ?", player_id, room_id).first
    end

    def update_player_room(player_id, room_id, data)
      ar_player_room = get_player_room(player_id, room_id)
      ar_player_room.update(data)
    end

    def delete_player_room(player_id, room_id)
      ar_player_room = get_player_room(player_id, room_id)
      ar_player_room.destroy
    end
  end
end
