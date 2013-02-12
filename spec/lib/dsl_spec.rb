require "spec_helper"

describe SmartApi::Dsl do
  include SmartApi::Dsl

  it "creates a endpoint description" do
    stub_desc = mock(:description)
    SmartApi::EndpointDescriptor.should_receive(:new).with(self, :show, "Retrieves the resource identified by parameter `id`", method: :get, content_type: "application/json", params: { id: { type: :integer } }).and_return(stub_desc)

    description =
      desc :show, "Retrieves the resource identified by parameter `id`", method: :get, content_type: "application/json", params: {
        id: { type: :integer },
      }

    description.should == stub_desc
  end
end