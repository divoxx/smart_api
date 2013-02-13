require "spec_helper"

describe SmartApi::Dsl do
  include SmartApi::Dsl

  it "creates a endpoint descriptor" do
    stub_desc = mock(:descriptor)
    SmartApi::EndpointDescriptor.should_receive(:new).with("Retrieves the resource identified by parameter `id`", method: :get, content_types: ["application/json"], params: { id: { type: :integer } }).and_return(stub_desc)

    descriptor =
      desc "Retrieves the resource identified by parameter `id`", method: :get, content_type: "application/json", params: {
        id: { type: :integer },
      }

    descriptor.should == stub_desc
  end
end