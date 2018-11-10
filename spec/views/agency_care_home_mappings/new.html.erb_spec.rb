require 'rails_helper'

RSpec.describe "agency_care_home_mappings/new", type: :view do
  before(:each) do
    assign(:agency_care_home_mapping, AgencyCareHomeMapping.new(
      :care_home_id => 1,
      :agency_id => 1
    ))
  end

  it "renders new agency_care_home_mapping form" do
    render

    assert_select "form[action=?][method=?]", agency_care_home_mappings_path, "post" do

      assert_select "input#agency_care_home_mapping_care_home_id[name=?]", "agency_care_home_mapping[care_home_id]"

      assert_select "input#agency_care_home_mapping_agency_id[name=?]", "agency_care_home_mapping[agency_id]"
    end
  end
end
