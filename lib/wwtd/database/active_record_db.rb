require 'active_record'
require 'pry'

module WWTD
  ActiveSupport::Inflector.inflections(:en) do |inflect|
    inflect.uncountable 'inventory'
    inflect.uncountable 'quest_progress'
  end

  class ActiveRecordDatabase
    def initialize
      config_path = File.expand_path('../../../../db/config.yml', __FILE__)
      config = YAML.load_file(config_path)
      app_env = ENV['DB_ENV'] || 'development'
      ActiveRecord::Base.establish_connection(config[app_env])
    end

    # Move specific class methods to other files
    class Quest < ActiveRecord::Base
      has_many :quest_items, dependent: :destroy
      has_many :quest_progress, dependent: :destroy
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
      has_many :quest_progress, dependent: :destroy
      has_many :inventory, dependent: :destroy
      has_many :quests, through: :quest_progress
      has_many :items, through: :inventory
      has_many :rooms, through: :player_rooms
      has_many :player_rooms, dependent: :destroy
    end

    class Item < ActiveRecord::Base
      has_many :inventory, dependent: :destroy
      has_many :quest_items, dependent: :destroy
      has_many :room_items, dependent: :destroy
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
    end

    class Room < ActiveRecord::Base
      has_many :room_items, dependent: :destroy
      has_many :quest_characters
      has_many :quest_items
      has_many :items, through: :quest_items
      has_many :characters, through: :quest_characters
      has_many :player_rooms
      has_many :players, through: :player_rooms
    end

    class QuestCharacter < ActiveRecord::Base
      belongs_to :quest
      belongs_to :character
    end

    class PlayerRoom < ActiveRecord::Base
      belongs_to :player
      belongs_to :room
    end

    def clear_tables
      Character.delete_all
      Player.delete_all
      Quest.delete_all
      Room.delete_all
      Item.delete_all
      RoomItem.delete_all
      Inventory.delete_all
      QuestProgress.delete_all
      QuestCharacter.delete_all
      QuestItem.delete_all
      PlayerRoom.delete_all
    end
  end
end
