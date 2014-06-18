module WWTD
  class ZombieNode
    attr_reader :id, :strength, :description, :roomId, :questId, :name
    def initialize(input={})
      @id = input[:id]
      @name = input[:name]
      @description = input[:description]
      @strength = input[:strength]
      @roomId = input[:roomId]
      @questId = input[:questId]
    end

    # bites uninfected player (CharacterNode)
    def bite(person)
      person.getBit
    end
  end
end
