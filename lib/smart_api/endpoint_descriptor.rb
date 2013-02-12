module SmartApi
  class EndpointDescriptor
    ParamDescriptor = Struct.new(:name, :type, :optional)

    attr_reader :controller, :action_name, :text_desc, :method, :content_types, :params

    def initialize(controller, action_name, text_desc, opts = {})
      @controller  = controller
      @action_name = action_name
      @text_desc   = text_desc
      build_from_options(opts)
    end

    private

    def build_from_options(opts)
      @method        = opts[:method] || :get
      @content_types = Array(opts[:content_types])

      @params = {}

      Array(opts[:params]).each do |name, attrs|
        @params[name] = ParamDescriptor.new(name, attrs[:type], attrs[:optional] || false)
      end

      @params.freeze
    end
  end
end
