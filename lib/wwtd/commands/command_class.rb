require 'ostruct'

module WWTD
  class Command
    # Convenience method that lets us call `.run` directly on the class
    def self.run(inputs)
      self.new.run(inputs)
    end

    def failure(error_sym, data={})
      CommandFailure.new(data.merge :error => error_sym)
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
