module SmartApi
  module Controller
    extend ActiveSupport::Concern

    included do
      class_attribute :_endpoint_descriptors
      self._endpoint_descriptors = {}
    end

    module ClassMethods
      def endpoint_descriptor_for(action)
        self._endpoint_descriptors[action]
      end

      def desc(action_name, *args)
        self._endpoint_descriptors[action_name] = Dsl.desc(action_name, *args)
      end
    end

    def params
      return @_params if @_params
      desc = self.class.endpoint_descriptor_for(action_name.to_sym)
      @_params = ParamsHandler.new(desc.params).handle(super)
    end
  end
end