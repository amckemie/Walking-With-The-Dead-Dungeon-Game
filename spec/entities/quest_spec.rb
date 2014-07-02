require 'spec_helper.rb'
require 'json'

describe WWTD::Quest do
  let(:quest1) {WWTD::Quest.new(id: 1, name: 'Quest 1', data: {phone: false, backpack: false})}

  it 'has an id' do
    expect(quest1.id).to eq(1)
  end

  it "has a name" do
    expect(quest1.name).to eq('Quest 1')
  end

  # this will be used later for json conversion
  it 'has a data attribute that points to a hash' do
    expect(quest1.data).to be_a(Hash)
    expect(quest1.data).to eq({phone: false, backpack: false})
  end
end
