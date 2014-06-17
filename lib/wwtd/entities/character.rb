module WWTD
  class CharacterNode
    attr_reader :id, :name, :description, :questId, :roomId

    def initialize(input)
      @id = input[:id]
      @name = input[:name]
      @description = input[:description]
      @questId = input[:questId]
      @roomId = input[:roomId]
    end
  end
end
