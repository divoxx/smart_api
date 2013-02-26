module SmartApi
  module Controller
    extend ActiveSupport::Concern

    include AbstractController::Callbacks
    include ActionController::ConditionalGet
    include ActionController::Head
    include ActionController::Instrumentation
    include ActionController::MimeResponds
    include ActionController::Redirecting
    include ActionController::Rendering
    include ActionController::Renderers::All
    include ActionController::Rescue
    include ActionController::UrlFor
    include Rails.application.routes.url_helpers

    included do
      append_view_path Rails.root.join("app", "views")
      self.responder = SmartApi::Responder
      class_attribute :_endpoint_descriptors
    end

    module ClassMethods
      def endpoint_descriptor_for(action)
        self._endpoint_descriptors[action]
      end

      def desc(action_name, *args)
        self._endpoint_descriptors ||= {}
        self._endpoint_descriptors[action_name] = Dsl.desc(*args)
      end
    end

    def params
      return @_params if @_params
      desc = self.class.endpoint_descriptor_for(action_name.to_sym)
      @_params = ParamsHandler.new(desc.params).handle(super)
    end
  end
end