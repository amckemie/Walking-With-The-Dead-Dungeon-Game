module WWTD
  class PersonNode
    attr_reader :name, :id
    attr_accessor :strength, :inventory

    def initialize(input)
      @id = input[:id]
      @name = input[:name]
      @strength = input[:strength]
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
