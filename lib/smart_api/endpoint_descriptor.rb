module SmartApi
  class EndpointDescriptor
    def initialize(controller, action_name, text_desc, opts = {})
      @controller   = controller
      @action_name  = action_name
      @text_desc    = text_desc
      @options      = opts.dup
    end
  end
end
