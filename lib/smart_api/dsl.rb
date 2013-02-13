module SmartApi
  module Dsl
    extend self

    def desc(text_desc, opts = {})
      if single_content_type = opts.delete(:content_type)
        opts[:content_types] = [single_content_type]
      end

      EndpointDescriptor.new(text_desc, opts)
    end
  end
end