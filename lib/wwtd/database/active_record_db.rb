require 'active_record'

module WWTD
  class ActiveRecordDatabase
    def initialize
      ActiveRecord::Base.establish_connection(
      :adapter => 'postgresql',
      :database => 'wwtd-test.db'
      )
    end

    class Zombie < ActiveRecord::Base
      belongs_to :room
    end

    class Person < ActiveRecord::Base
      belongs_to :room
    end

    class Player < ActiveRecord::Base
      validates :username, uniqueness: true
      validates :password, length: {minimum: 8}
      validates :username, :password, presence: true
      belongs_to :room
      has_many :items, through: :itemsplayers
    end

    class Item < ActiveRecord::Base
      has_many :players, through: :itemsplayers
    end

    class ItemsPlayer < ActiveRecord::Base
      belongs_to :item
      belongs_to :player
    end

    class Weapon < ActiveRecord::Base
      has_many :players
    end

    class Room < ActiveRecord::Base
      has_many :players
      has_many :zombies
      has_many :people
    end

    def clear_tables
      Zombie.delete_all
      Person.delete_all
      Player.delete_all
      Item.delete_all
      ItemsPlayer.delete_all
      Weapon.delete_all
      Room.delete_all
    end
  end
end
