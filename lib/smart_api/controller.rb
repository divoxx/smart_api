module SmartApi
  module Controller
    extend ActiveSupport::Concern

    include ActionController::ConditionalGet
    include ActionController::Head
    include ActionController::Instrumentation
    include ActionController::MimeResponds
    include ActionController::Redirecting
    include ActionController::Rendering
    include ActionController::Rescue
    include ActionController::UrlFor
    include Rails.application.routes.url_helpers

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
      return @_smart_api_params if @_smart_api_params
      desc = self.class.endpoint_descriptor_for(action_name.to_sym)
      @_smart_api_params = ParamsHandler.new(desc.params).handle(super)
    end
  end
end