module WWTD
  class PersonNode
    attr_reader :name, :id, :description
    attr_accessor :strength, :inventory, :infected, :dead

    def initialize(input)
      @id = input[:id]
      @name = input[:name]
      @description = input[:description]
      @strength = input[:strength]
      @inventory = []
      @infected = false
      @dead = false
    end

    def getBit
      @infected = true
    end

    def addToInventory(itemNode)
      @inventory << itemNode
    end

    def removeFromInventory(itemNode)
      @inventory.delete(itemNode)
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
