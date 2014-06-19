module WWTD
  class ZombieNode
    attr_reader :id, :strength, :description, :room_id, :quest_id, :name, :dead
    def initialize(input={})
      @id = input[:id]
      @name = input[:name]
      @description = input[:description]
      @strength = input[:strength]
      @room_id = input[:room_id]
      @quest_id = input[:quest_id]
      @dead = input[:dead]
    end

    # bites uninfected player (CharacterNode)
    def bite(person)
      person.getBit
    end
  end
end
