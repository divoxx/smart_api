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

        type_cast_func = Converters[desc.type]
        raise ArgumentError, "unknown type #{desc.type.inspect}" if type_cast_func.nil?

        begin
          new_params[name] = type_cast_func.(params_hash[name])
        rescue TypeError, ArgumentError
          errors[name] = "is not a valid #{desc.type}"
        end
      end

      Parameters.new(new_params.freeze, errors.freeze)
    end

    class Parameters < Struct.new(:values, :errors)
      delegate :slice, :except, :values_at, :has_key?, :==, :[], :delete, :fetch, :to_hash, :to => :values
    end
  end
end