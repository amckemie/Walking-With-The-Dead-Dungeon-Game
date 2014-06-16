module WWTD
  class PersonNode
    attr_reader :name
    def initialize(name, strength)
      @name = name
      @strength = strength
      @inventory = []
    end

    def fight(opponent)
    end

    def eat(food)
    end

    def rest
    end

    def drink(bev)
    end
  end
end
