module WWTD
  class CharacterNode
    attr_reader :id, :name, :description, :quest_id, :room_id, :dead

    def initialize(input)
      @id = input[:id]
      @name = input[:name]
      @description = input[:description]
      @quest_id = input[:quest_id]
      @room_id = input[:room_id]
      @dead = input[:dead]
    end
  end
end
