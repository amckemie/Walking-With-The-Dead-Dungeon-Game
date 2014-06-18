require 'active_record'

module WWTD
  class ActiveRecordDatabase
    def initialize
      ActiveRecord::Base.establish_connection(
      :adapter => 'postgresql',
      :database => 'wwtd-test.db'
      )
    end

    class Quest < ActiveRecord::Base
      has_many :items, through: :questItems
      has_many :characters, through: :questCharacters
      has_many :players, through: :questProgress
    end

    class Character < ActiveRecord::Base
      belongs_to :room
      belongs_to :quest
    end

    class Player < ActiveRecord::Base
      validates :username, uniqueness: true
      validates :password, length: {minimum: 8}
      validates :username, :password, presence: true
      has_many :quests, through: :questProgress
      has_many :items, through: :inventory
    end

    class Item < ActiveRecord::Base
      has_many :players, through: :inventory
      has_many :quests, through: :questItems
      has_many :rooms, through: :roomItems
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
      has_many :players
      has_many :items, through: :roomItems
      has_many :characters, through: :roomCharacters
    end

    def clear_tables
      Character.delete_all
      Player.delete_all
      Quest.delete_all
      Room.delete_all
      Item.delete_all
      RoomCharacter.delete_all
      RoomItem.delete_all
      Inventory.delete_all
      QuestProgress.delete_all
      QuestCharacter.delete_all
      QuestItem.delete_all
    end
  end
end
