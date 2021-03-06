module WWTD
  class ActiveRecordDatabase
    def create_room(attrs)
      ar_room = Room.create(attrs)
      build_room(ar_room)
    end

    def build_room(room)
      # WWTD::RoomNode.new(room)
      WWTD::Room.new(id: room.id,
        name: room.name,
        description: room.description,
        quest_id: room.quest_id,
        start_new_quest: room.start_new_quest,
        north: room.north,
        east: room.east,
        south: room.south,
        west: room.west,
        canN: room.canN,
        canE: room.canE,
        canS: room.canS,
        canW: room.canW
      )
    end

    def get_room(room_id)
      ar_room = Room.find(room_id)
      build_room(ar_room)
    end

    def get_first_room
      ar_room = Room.first
      build_room(ar_room)
    end

    def get_all_quest_rooms(quest_id)
      ar_rooms = Room.where('quest_id = ?', quest_id)
      return nil if ar_rooms.length < 1
      ar_rooms.map {|room| build_room(room)}
    end

    def update_room(room_id, data)
      ar_room = Room.find(room_id)
      ar_room.update(data)
      build_room(ar_room)
    end

    def delete_room(q_id)
      ar_room = Room.find(q_id)
      ar_room.destroy
      return true if !Room.exists?(q_id)
    end
  end
end
