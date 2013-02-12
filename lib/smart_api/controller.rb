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
  end
end