module WWTD
  class Quest
    attr_reader :id, :name, :data
    def initialize(input)
      @id = input[:id]
      @name = input[:name]
      @data = input[:data] ||= {}
    end
  end
end
