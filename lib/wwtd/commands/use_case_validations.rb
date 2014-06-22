require 'ostruct'

class UseCase

  class Validator
    include ActiveModel::Validations

    # define alias 'allow' for attr_accessor'
    self.singleton_class.send :alias_method, :allow, :attr_accessor

    # Needed to keep active_model happy
    def self.model_name
      ActiveModel::Name.new(self, nil, 'validator')
    end

    def initialize(attrs)
      attrs.each do |name, val|
        self.send "#{name}=", val
      end
    end

  end

  def validate_params(params, &block)
    validate_class = Class.new(Validator, &block)
    validate_class.new(params)
  end

  def failure(error_name, extra)
    hash = { :success? => false, :error => error_name }
    return OpenStruct.new(hash.merge(extra))
  end

  def success(data)
    return OpenStruct.new(data.merge(:success? => true))
  end
end
