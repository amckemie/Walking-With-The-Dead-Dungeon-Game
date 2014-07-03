module WWTD
  class PlayerNode
    attr_reader :id, :description, :dead, :room_id, :password
    attr_accessor :strength, :username, :inventory

    def initialize(input)
      @id = input[:id]
      @username = input[:username]
      @password = input[:password]
      @description = input[:description]
      @strength = input[:strength]
      @inventory = []
      @room_id = input[:room_id]
      @dead = false
    end

    def getBit
      @dead = true
    end

    def eat(food)
      return false if !inInventory?(food)

      if(@strength != 100)
        increasedStrength = @strength + (@strength * 0.2)
        if ((increasedStrength) >= 100)
          @strength = 100
        else
          @strength = increasedStrength
        end
      end
      @inventory.delete(food)
      return true
    end

    def inInventory?(item)
      @inventory.include?(item)
    end

    def rest
      @strength >= 85 ? @strength = 100 : @strength = @strength + 15
    end

    def drink(bev)
      return false if !inInventory?(bev)
      bev.name == 'water' ? amount = 0.15 : amount = 0.1

      if(@strength != 100)
        increasedStrength = @strength + (@strength * amount)
        if ((increasedStrength) >= 100)
          @strength = 100
        else
          @strength = increasedStrength
        end
      end
      @inventory.delete(bev)
      return true
    end
  end
end
