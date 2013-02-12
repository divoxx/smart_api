require "spec_helper"

describe SmartApi::EndpointDescriptor do
  it "describes an API endpoint" do
    described_class.new(
      mock(:controller),
      :action_name,
      "API Endpoint Description",
      method: :get, content_types: ["application/json"], params: { id: mock(:param_desc) }
    )
  end
end