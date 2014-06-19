require 'active_record'
require 'pry'

module WWTD
  class ActiveRecordDatabase
    def initialize
      ActiveRecord::Base.establish_connection(
      :adapter => 'postgresql',
      :database => 'walking_with_the_dead_test'
      )
    end

    # Move to other file?
    class Quest < ActiveRecord::Base
      # has_many :quest_items, dependent: :destroy
      # has_many :quest_progresses, dependent: :destroy
      has_many :items, through: :quest_items
      # has_many :characters, through: :quest_characters
      has_many :players, through: :quest_progress
    end

    class Character < ActiveRecord::Base
      belongs_to :room
      belongs_to :quest
    end

    class Player < ActiveRecord::Base
      validates :username, uniqueness: true
      validates :password, length: {minimum: 8}
      validates :username, :password, presence: true
      # has_many :quest_progresses, dependent: :destroy
      # has_many :inventories, dependent: :destroy
      has_many :quests, through: :quest_progress
      has_many :items, through: :inventory
    end

    class Item < ActiveRecord::Base
      has_many :inventories, dependent: :destroy
      has_many :quest_items, dependent: :destroy
      has_many :room_items, dependent: :destroy
      has_many :players, through: :inventory
      has_many :quests, through: :quest_items
      has_many :rooms, through: :room_items
    end

    class QuestItem < ActiveRecord::Base
      belongs_to :quest
      belongs_to :item
    end

    class QuestCharacter < ActiveRecord::Base
      belongs_to :quest
      belongs_to :character
    end

    class QuestProgress < ActiveRecord::Base
      belongs_to :quest
      belongs_to :player
    end

    class Inventory < ActiveRecord::Base
      belongs_to :item
      belongs_to :player
    end

    class RoomItem < ActiveRecord::Base
      belongs_to :room
      belongs_to :item
    end

    class Room < ActiveRecord::Base
      # has_many :players
      # may not need this: double check at end
      # has_many :room_items, dependent: :destroy
      has_many :items, through: :room_items
      has_many :characters, through: :quest_characters
    end

    def clear_tables
      Character.delete_all
      Player.delete_all
      Quest.delete_all
      Room.delete_all
      # Item.delete_all
      # RoomItem.delete_all
      # Inventory.delete_all
      # QuestProgress.delete_all
      # QuestCharacter.delete_all
      # QuestItem.delete_all
    end

    # Quest Methods
    def create_quest(attrs)
      ar_quest = Quest.create(attrs)
      build_quest(ar_quest)
    end

    def build_quest(quest)
      WWTD::Quest.new(id: quest.id, name: quest.name)
    end

    def update_quest(q_id, data)
      ar_quest = Quest.find(q_id)
      ar_quest.update(data)
      build_quest(ar_quest)
    end

    def get_quest(q_id)
      ar_quest = Quest.find(q_id)
      build_quest(ar_quest)
    end

    def delete_quest(q_id)
      ar_quest = Quest.find(q_id)
      ar_quest.destroy
      return true if !Quest.exists?(q_id)
    end

    # Character Methods
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
      build_character(ar_character)
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
      build_character(ar_character)
    end

    def delete_character(q_id)
      ar_character = Character.find(q_id)
      ar_character.destroy
      return true if !Character.exists?(q_id)
    end

    def get_all_quest_characters(q_id)
      result = []
      chars = Character.where('quest_id = ?', q_id)
      chars.each do |i|
        if i.classification == 'person'
          result << build_character(i)
        else
          result << build_zombie(i)
        end
      end
      result
    end

    def get_all_room_characters(room_id)
      result = []
      chars = Character.where('room_id = ?', room_id)
      chars.each do |i|
        if i.classification == 'person'
          result << build_character(i)
        else
          result << build_zombie(i)
        end
      end
      result
    end

    def get_room_and_quest_characters(q_id, room_id)
      result = []
      chars = Character.where('quest_id = ? AND room_id = ?', q_id, room_id)
      chars.each do |i|
        if i.classification == 'person'
          result << build_character(i)
        else
          result << build_zombie(i)
        end
      end
      result
    end

    # Room Methods

    def create_room(attrs)
      ar_room = Room.create(attrs)
      build_room(ar_room)
    end

    def build_room(room)
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

    # Player methods
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

    def get_player(player_id)
      ar_player = Player.find(player_id)
      # binding.pry
      build_player(ar_player)
    end

    def get_player_by_username(player_un)
      ar_player = Player.find_by(username: player_un)
      # binding.pry
      build_player(ar_player)
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
