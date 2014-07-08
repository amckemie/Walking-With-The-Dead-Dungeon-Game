module WWTD
  class ActiveRecordDatabase
    def create_character(attrs)
      ar_character = Character.create(attrs)
      ar_character.classification == 'person' ? build_character(ar_character) : build_zombie(ar_character)
    end

    def build_character(character)
      WWTD::CharacterNode.new(character)
    end

    def get_character(char_id)
      ar_character = Character.find(char_id)
      ar_character.classification == 'person' ? build_character(ar_character) : build_zombie(ar_character)
    end

    def get_character_by_name(char_name)
      ar_character = Character.find_by(name: char_name)
      ar_character.classification == 'person' ? build_character(ar_character) : build_zombie(ar_character)
    end

    def build_zombie(zombie)
      WWTD::ZombieNode.new(zombie)
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
      chars.map {|char| char.classification == 'person' ? build_character(char) : build_zombie(char) }
    end

    def get_all_room_characters(room_id)
      chars = Character.where('room_id = ?', room_id)
      chars.map {|char| char.classification == 'person' ? build_character(char) : build_zombie(char) }
    end

    def get_room_and_quest_characters(q_id, room_id)
      chars = Character.where('quest_id = ? AND room_id = ?', q_id, room_id)
      chars.map {|char| char.classification == 'person' ? build_character(char) : build_zombie(char) }
    end
  end
end
