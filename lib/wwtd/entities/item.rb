module WWTD
  class ItemNode
    attr_reader :name, :id, :type, :description
    attr_accessor :actions, :location_type, :location_id
    def initialize(input)
      @id = input[:id]
      @type = input[:type]
      @name = input[:name]
      @description = input[:description]
      @actions = input[:actions]
      @location_type = input[:location_type]
      @location_id = input[:location_id]
    end
  end

  class WeaponNode < ItemNode
    attr_reader :name, :id
    attr_accessor :actions
    def initialize(input)
      super(input)
    end
  end
end
