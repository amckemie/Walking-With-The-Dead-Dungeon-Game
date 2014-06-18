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
      has_many :quest_progresses, dependent: :destroy
      has_many :inventories, dependent: :destroy
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
      has_many :room_items, dependent: :destroy
      has_many :items, through: :room_items
      has_many :characters, through: :quest_characters
    end

    def clear_tables
      Character.delete_all
      # Player.delete_all
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
      ar_character.type == 'person' ? build_character(ar_character) : build_zombie(ar_character)
    end

    def build_character(character)
      WWTD::CharacterNode.new(id: character.id,
        name: character.name,
        description: character.description,
        quest_id: character.quest_id,
        room_id: character.room_id
      )
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

    # def get_character
  end
end
