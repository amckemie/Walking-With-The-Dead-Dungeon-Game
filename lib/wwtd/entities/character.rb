module WWTD
  class CharacterNode
    attr_reader :id, :name, :description, :quest_id, :room_id

    def initialize(input)
      @id = input[:id]
      @name = input[:name]
      @description = input[:description]
      @questId = input[:questId]
      @room_id = input[:room_id]
    end
  end
end
