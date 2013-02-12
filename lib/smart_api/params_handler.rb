module SmartApi
  class ParamsHandler
    Converters = {
      integer: ->(v) { Integer(v, 10) },
      string:  ->(v) { String(v) },
      float:   ->(v) { Float(v) },
      date:    ->(v) { Date.parse(v) },
      time:    ->(v) { Time.parse(v) },
      bool:    ->(v) { v == true || v == "1" || v == "t" },
    }

    def initialize(descriptors)
      @descriptors = descriptors
    end

    def handle(params_hash)
      new_params = {}
      errors     = {}

      @descriptors.each do |name, desc|
        if params_hash[name].blank?
          if !desc.optional?
            errors[name] = "is required"
          end
          next
        end

        begin
          new_params[name] = Converters[desc.type].(params_hash[name])
        rescue TypeError, ArgumentError
          errors[name] = "is not a valid #{desc.type}"
        end
      end

      Parameters.new(new_params.freeze, errors.freeze)
    end

    class Parameters < Struct.new(:values, :errors)
      delegate :slice, :except, :has_key?, :==, :[], :to_hash, :to => :values
    end
  end
end