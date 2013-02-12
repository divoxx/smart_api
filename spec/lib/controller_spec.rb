require "spec_helper"

describe SmartApi::Controller do
  subject do
    Class.new do
      include SmartApi::Controller
    end
  end

  it "stores endpoint descriptors on the controller" do
    stub_desc = mock(:endpoint_descriptor)
    SmartApi::Dsl.should_receive(:desc).with(:action_name, "Text").and_return(stub_desc)
    subject.desc :action_name, "Text"
    subject.endpoint_descriptor_for(:action_name).should == stub_desc
  end
end