module WWTD
  class ActiveRecordDatabase
    def create_quest_character(attrs)
      QuestCharacter.create!(attrs)
    end

    # could be done by creating player /char association, finding all chars for player, then using .where to find quests? Which is faster?
    def get_players_quest_characters(player_id, quest_id)
      chars = QuestCharacter.where('player_id = ? AND quest_id = ?', player_id, quest_id)
      return nil if chars.empty?
      chars.map { |character|
        char = Character.find(character.character_id)
        build_character(char)
      }
    end

    def get_player_room_characters(player_id, room_id)
      chars = QuestCharacter.where('player_id = ? AND room_id = ?', player_id, room_id)
      return nil if chars.empty?
      chars.map { |character|
        char = Character.find(character.character_id)
        char.classification == 'person' ? build_character(char) : build_zombie(char)
      }
    end

    def get_zombie_characters(player_id, room_id)
      chars = get_player_room_characters(player_id, room_id)
      chars.delete_if {|character| character.class == WWTD::CharacterNode}
    end

    def delete_quest_character(player_id, character_id)
      ar_quest_character = QuestCharacter.where('player_id = ? AND character_id = ?', player_id, character_id).first
      test_id = ar_quest_character.id
      ar_quest_character.destroy
      return true if !QuestCharacter.exists?(test_id)
    end

    def delete_all_quest_characters(player_id, quest_id)
      ar_quest_characters = QuestCharacter.where('player_id = ? AND quest_id = ?', player_id, quest_id)
      ar_quest_characters.each do |record|
        record.destroy
      end
      return true if !get_players_quest_characters(player_id, quest_id)
    end
  end
end
