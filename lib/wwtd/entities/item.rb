module WWTD
  class ItemNode
    attr_reader :name, :id, :classification, :description
    attr_accessor :location_type, :location_id, :actions
    def initialize(input)
      @id = input[:id]
      @classification = input[:classification]
      @name = input[:name]
      @description = input[:description]
      @actions = input[:actions]
      @location_type = input[:location_type]
      @location_id = input[:location_id]
    end
  end
end
