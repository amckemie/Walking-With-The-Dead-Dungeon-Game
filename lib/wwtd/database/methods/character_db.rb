module WWTD
  class ActiveRecordDatabase
    def create_character(attrs)
      ar_character = Character.create(attrs)
      ar_character.classification == 'person' ? build_character(ar_character) : build_zombie(ar_character)
    end

    def build_character(character)
      WWTD::CharacterNode.new(id: character.id,
        name: character.name,
        description: character.description,
        quest_id: character.quest_id,
        room_id: character.room_id,
        dead: character.dead
      )
    end

    def get_character(char_id)
      ar_character = Character.find(char_id)
      ar_character.classification == 'person' ? build_character(ar_character) : build_zombie(ar_character)
    end

    def build_zombie(zombie)
      WWTD::ZombieNode.new(id: zombie.id,
        name: zombie.name,
        description: zombie.description,
        strength: zombie.strength,
        quest_id: zombie.quest_id,
        room_id: zombie.room_id
      )
    end

    def update_character(char_id, data)
      ar_character = Character.find(char_id)
      ar_character.update(data)
      ar_character.classification == 'person' ? build_character(ar_character) : build_zombie(ar_character)
    end

    def delete_character(char_id)
      ar_character = Character.find(char_id)
      ar_character.destroy
      return true if !Character.exists?(char_id)
    end

    def get_all_quest_characters(q_id)
      chars = Character.where('quest_id = ?', q_id)
      chars.map {|i|
        if i.classification == 'person'
           build_character(i)
        else
          build_zombie(i)
        end
      }
    end

    def get_all_room_characters(room_id)
      chars = Character.where('room_id = ?', room_id)
      chars.map {|i|
        if i.classification == 'person'
           build_character(i)
        else
          build_zombie(i)
        end
        }
    end

    def get_room_and_quest_characters(q_id, room_id)
      chars = Character.where('quest_id = ? AND room_id = ?', q_id, room_id)
      chars.map {|i|
        if i.classification == 'person'
           build_character(i)
        else
          build_zombie(i)
        end
        }
    end
  end
end
