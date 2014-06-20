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

    # Move specific class methods to other files
    class Quest < ActiveRecord::Base
      has_many :quest_items, dependent: :destroy
      # has_many :quest_progresses, dependent: :destroy
      has_many :quest_characters, dependent: :destroy
      has_many :items, through: :quest_items
      has_many :characters, through: :quest_characters
      has_many :players, through: :quest_progress
      has_many :rooms, through: :quest_items
    end

    class Character < ActiveRecord::Base
      has_one :quest
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
      # has_many :inventories, dependent: :destroy
      has_many :quest_items, dependent: :destroy
      # has_many :room_items, dependent: :destroy
      has_many :players, through: :inventory
      has_many :quests, through: :quest_items
      has_many :rooms, through: :quest_items
    end

    class QuestItem < ActiveRecord::Base
      belongs_to :quest
      belongs_to :item
      belongs_to :room
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
      # belongs_to :player
    end

    class Room < ActiveRecord::Base
      # has_many :players
      # may not need this: double check at end
      # has_many :room_items, dependent: :destroy
      has_many :quest_characters
      has_many :quest_items
      has_many :items, through: :quest_items
      has_many :characters, through: :quest_characters
    end

    class QuestCharacter < ActiveRecord::Base
      belongs_to :quest
      belongs_to :character
    end

    def clear_tables
      Character.delete_all
      Player.delete_all
      Quest.delete_all
      Room.delete_all
      Item.delete_all
      # RoomItem.delete_all
      # Inventory.delete_all
      # QuestProgress.delete_all
      QuestCharacter.delete_all
      QuestItem.delete_all
      # PlayerQuestCharacter.delete_all
    end
  end
end
