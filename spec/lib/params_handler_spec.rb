require "spec_helper"

describe SmartApi::ParamsHandler do
  let :descriptors do
    {
      id: mock(:id_desc, type: :integer, optional?: false),
      name: mock(:name_desc, type: :string, optional?: true),
      rating: mock(:rating_desc, type: :float, optional?: true),
      birthday: mock(:birthday_desc, type: :date, optional?: true),
      updated_at: mock(:updated_at_desc, type: :time, optional?: true),
     }
  end

  let :valid_params do
    { id: "01", name: "rodrigo", rating: "10", birthday: "1985-10-31", updated_at: "2013-02-12 14:18:00" }
  end

  subject do
    described_class.new(descriptors)
  end

  it "typecast defined parameters" do
    params = subject.handle(valid_params)
    params.should == { id: 1, name: "rodrigo", rating: 10.0, birthday: Date.civil(1985, 10, 31), updated_at: Time.parse("2013-02-12 14:18:00") }
    params.errors.should be_empty
  end

  it "does not accept nil for non optional params" do
    params = subject.handle(valid_params.except(:id))
    params.errors[:id].should == "is required"
  end

  it "accepts nil for optional params" do
    params = subject.handle(valid_params.except(:name))
    params.errors.should_not have_key(:name)
  end
end