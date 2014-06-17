module WWTD
  class ZombieNode
    attr_reader :id, :strength, :description, :killed, :roomId, :questId
    def initialize(input={})
      @id = input[:id]
      @description = input[:description]
      @strength = input[:strength]
      @roomId = input[:roomId]
      @questId = input[:questId]
      @killed = false
    end

    # bites uninfected player (CharacterNode)
    def bite(person)
      person.getBit
    end
  end
end
