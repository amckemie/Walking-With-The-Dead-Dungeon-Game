require 'spec_helper.rb'

describe WWTD::CharacterNode do
  let(:character1) {WWTD::CharacterNode.new(id: 10, name: 'Susie', description: 'best friend', quest_id: 1, room_id: 8, dead: false)}
  it "has an id" do
    expect(character1.id).to eq(10)
  end

  it 'has a name' do
    expect(character1.name).to eq("Susie")
  end

  it 'has a description' do
    expect(character1.description).to eq("best friend")
  end

  it 'has a questId' do
    expect(character1.quest_id).to eq(1)
  end

  it 'has a roomId' do
    expect(character1.room_id).to eq(8)
  end

  it 'has a dead attribute' do
    expect(character1.dead).to eq(false)
  end
end
