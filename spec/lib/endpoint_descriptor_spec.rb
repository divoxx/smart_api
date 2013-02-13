require "spec_helper"

describe SmartApi::EndpointDescriptor do
  let :controller do
    mock(:controller)
  end

  subject do
    described_class.new(
      "API Endpoint Description",
      method: :put, content_types: ["application/json"], params: { id: {type: :integer} }
    )
  end

  it "describes the endpoint textually" do
    subject.text_desc.should == "API Endpoint Description"
  end

  it "describes the http method" do
    subject.method.should be :put
  end

  it "describes the accepted content types" do
    subject.content_types.should == ["application/json"]
  end

  it "describes the accepted parameters" do
    id = subject.params[:id]
    id.should be_a(SmartApi::EndpointDescriptor::ParamDescriptor)
    id.name.should == :id
    id.type.should == :integer
    id.optional.should == false
  end
end