require 'ostruct'

module WWTD
  class Command
    def self.run(input)
      self.new.run(input)
    end

    def failure(error_message, data={})
      CommandFailure.new(data.merge :error => error_message)
    end

    def success(data={})
      CommandSuccess.new(data)
    end
  end

  class CommandFailure < OpenStruct
    def success?
      false
    end
  end

  class CommandSuccess < OpenStruct
    def success?
      true
    end
  end
end
