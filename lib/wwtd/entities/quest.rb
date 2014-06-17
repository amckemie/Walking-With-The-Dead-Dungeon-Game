module WWTD
  class Quest
    attr_reader :id, :name, :data, :complete
    def initialize(input)
      @id = input[:id]
      @name = input[:name]
      @data = input[:data] ||= {}
      @complete = input[:complete]
    end
  end
end
