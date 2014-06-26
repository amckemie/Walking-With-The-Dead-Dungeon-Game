module WWTD
  class ActiveRecordDatabase
    def create_room(attrs)
      ar_room = Room.create(attrs)
      build_room(ar_room)
    end

    def build_room(room)
      # WWTD::RoomNode.new(room)
      WWTD::RoomNode.new(id: room.id,
        name: room.name,
        description: room.description,
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
