module WWTD
  class ZombieNode
    attr_reader :id, :strength
    attr_accessor :description, :canGrab, :canWalk
    def initialize(input)
      @id = input[:id]
      @description = input[:description]
      @strength = input[:strength]
      @canGrab = input[:canGrab]
      @canWalk = input[:canWalk]
    end

    # bites uninfected player (PersonNode)
    def bite(person)
      person.getBit
    end
  end
end
