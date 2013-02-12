module SmartApi
  module Dsl
    extend self

    def desc(action_name, text_desc, opts = {})
      if single_content_type = opts.delete(:content_type)
        opts[:content_types] = [single_content_type]
      end

      EndpointDescriptor.new(self, action_name, text_desc, opts)
    end
  end
end