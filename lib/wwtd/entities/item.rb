module WWTD
  class ItemNode
    attr_reader :name, :id, :classification, :description, :actions, :parent_item, :room_id
    def initialize(input)
      @id = input[:id]
      @classification = input[:classification]
      @name = input[:name]
      @description = input[:description]
      @actions = input[:actions]
      @room_id = input[:room_id]
      @parent_item = input[:parent_item] || 0
    end
  end
end
