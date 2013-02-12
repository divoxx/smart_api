module SmartApi
  module Dsl
    extend self

    def desc(action_name, text_desc, opts = {})
      EndpointDescriptor.new(self, action_name, text_desc, opts)
    end
  end
end