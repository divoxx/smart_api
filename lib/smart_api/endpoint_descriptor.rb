module SmartApi
  class EndpointDescriptor
    attr_reader :text_desc, :method, :content_types, :params

    def initialize(text_desc, opts = {})
      @text_desc = text_desc
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

    class ParamDescriptor < Struct.new(:name, :type, :optional)
      def optional?
        self.optional ? true : false
      end
    end
  end
end
