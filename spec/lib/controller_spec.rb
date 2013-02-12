require "spec_helper"

describe SmartApi::Controller do
  let :stub_desc do
    stub_desc = mock(:endpoint_descriptor)
  end

  subject do
    ctrl_methods = Module.new do
      def params; {id: "1"}; end
      def action_name; :action_name; end
    end

    Class.new do
      include ctrl_methods
      include SmartApi::Controller
      desc :action_name, "Text", params: { id: { type: :integer } }
    end
  end

  before do
    SmartApi::Dsl.stub(:desc).with(:action_name, "Text", params: { id: { type: :integer } }).and_return(stub_desc)
  end

  it "stores endpoint descriptors on the controller" do
    subject.endpoint_descriptor_for(:action_name).should == stub_desc
  end

  it "handle parameters" do
    params_handler = mock(:params_handler)
    params = mock(:params)

    SmartApi::ParamsHandler.should_receive(:new).with(stub_desc).and_return(params_handler)
    params_handler.should_receive(:handle).with({ id: "1" }).and_return(params)

    subject.new.params.should == params
  end
end