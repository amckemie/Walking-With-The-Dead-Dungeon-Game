module WWTD
  class ItemNode
    attr_reader :name, :id, :type
    attr_accessor :actions
    def initialize(input)
      @id = input[:id]
      @type = input[:type]
      @name = input[:name]
      @actions = input[:actions]
    end
  end

  class WeaponNode < ItemNode
    attr_reader :name, :id
    attr_accessor :actions
    def initialize(name)
      super(input)
    end
  end
end
