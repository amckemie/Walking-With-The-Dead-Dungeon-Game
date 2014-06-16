require 'spec_helper'

describe 'WWTD database singleton' do
  it "always returns the same object" do
    database1 = WWTD.db
    database2 = WWTD.db
    # Create some data just in case
    database1.create_item(:name => 'test')

    # They should still be equal
    expect(database1).to eq database2
  end

  it "resets for every test" do
    expect(WWTD.db.all_items.count).to eq 0
  end
end
