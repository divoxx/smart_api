require "spec_helper"

describe SmartApi::Responder do
  let :request do
    mock(:request, get?: false, post?: false, put?: false, delete?: false)
  end

  let :controller do
    mock(:controller, request: request, stale?: true)
  end

  let :resources do
    [mock(:resource, valid?: true, persisted?: true, changed?: false)]
  end

  let :opts do
    {}
  end

  subject do
    described_class.new(controller, resources, opts)
  end

  it "responds with '200 OK' when successfully retrieving a resource" do
    request.stub(get?: true)
    controller.should_receive(:render)
    subject.respond
  end

  it "responds with '304 Not Modified' when retrieving a resource which cache is still fresh" do
    request.stub(get?: true)
    controller.should_not_receive(:render)
    controller.should_receive(:stale?).and_return(false)
    subject.respond
  end

  it "responds with '404 Not Found' when trying to retrieve a record that does not exist" do
    request.stub(get?: true)
    resources.clear
    controller.should_receive(:render).with(status: :not_found)
    subject.respond
  end

  it "responds with '201 Created' when successfully creating a new resource" do
    request.stub(post?: true)
    resources.last.stub(persisted?: true)
    controller.should_receive(:render).with(status: :created)
    subject.respond
  end

  it "responds with '400 Bad Request' when failed to create a new resource because of provided data" do
    request.stub(post?: true)
    resources.last.stub(persisted?: false, valid?: false, errors: { name: 'is required' })
    controller.should_receive(:render).with(json: { error: "Invalid attributes", attributes: { name: 'is required' } }, status: :bad_request)
    subject.respond
  end

  it "responds with '204 No Content' when successfully updating a resource" do
    request.stub(put?: true)
    resources.last.stub(persisted?: true)
    controller.should_receive(:render).with(status: :no_content)
    subject.respond
  end

  it "responds with '400 Bad Request' when failed to update a resource because of provided data" do
    request.stub(put?: true)
    resources.last.stub(persisted?: true, changed?: true, valid?: false, errors: { name: 'is required' })
    controller.should_receive(:render).with(json: { error: "Invalid attributes", attributes: { name: 'is required' } }, status: :bad_request)
    subject.respond
  end

  it "responds with '404 Not Found' when trying to update a record that does not exist" do
    request.stub(put?: true)
    resources.clear
    controller.should_receive(:render).with(status: :not_found)
    subject.respond
  end

  it "responds with '205 Reset Content' when successfully deleting a resource" do
    request.stub(delete?: true)
    controller.should_receive(:render).with(status: :reset_content)
    subject.respond
  end

  it "responds with '404 Not Found' when trying to delete a record that does not exist" do
    request.stub(delete?: true)
    resources.clear
    controller.should_receive(:render).with(status: :not_found)
    subject.respond
  end
end