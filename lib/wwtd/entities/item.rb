module WWTD
  class ItemNode
    attr_reader :name, :id, :classification, :description, :actions, :parent_item
    # attr_accessor :location_type, :location_id,
    def initialize(input)
      @id = input[:id]
      @classification = input[:classification]
      @name = input[:name]
      @description = input[:description]
      @actions = input[:actions]
      # don't think I need these
      # @location_type = input[:location_type]
      # @location_id = input[:location_id]
      @parent_item = input[:parent_item] || 0
    end
  end
end
