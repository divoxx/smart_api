require "spec_helper"

describe SmartApi::Controller do
  let :request do
    mock(:request, parameters: { "id" => "1" })
  end

  let :param_descs do
    { id: mock(:param_id_desc) }
  end

  let :endpoint_desc do
    stub_desc = mock(:endpoint_desc, params: param_descs)
  end

  subject do
    Class.new(ActionController::Metal) do
      include SmartApi::Controller
      desc :action_name, "Text", params: { id: { type: :integer } }
    end
  end

  before do
    SmartApi::Dsl.stub(:desc).with(:action_name, "Text", params: { id: { type: :integer } }).and_return(endpoint_desc)
    subject.any_instance.stub(action_name: :action_name, request: request)
  end

  it "stores endpoint descriptors on the controller" do
    subject.endpoint_descriptor_for(:action_name).should == endpoint_desc
  end

  it "handle parameters" do
    params_handler = mock(:params_handler)
    params = mock(:params)

    SmartApi::ParamsHandler.should_receive(:new).with(param_descs).and_return(params_handler)
    params_handler.should_receive(:handle).with(request.parameters).and_return(params)

    subject.new.params.should == params
  end

  it "sets the responder" do
    subject.responder.should be SmartApi::Responder
  end
end