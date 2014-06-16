require 'spec_helper.rb'

describe WWTD::ItemNode do
  let(:bedroom) {WWTD::RoomNode.new(id: 1, name: 'Bedroom', description: 'A bedroom', items: [sword.id])}
  let(:ashley) {WWTD::PersonNode.new(id: 1, name: 'Ashley', strength: 100)}
  let(:jacket) {WWTD::ItemNode.new(type: 'item', id: 1, name: 'jacket', actions: ['wear', 'put on'], location_type: ashley.class, location_id: ashley.id)}
  let(:sword) {WWTD::WeaponNode.new(type: 'weapon', id: 1, name: 'sword', actions: ['cut', 'stab'], location_type: bedroom.class, location_id: bedroom.id)}

  describe 'ItemNode' do

    it "has a type of item" do
      expect(jacket.type).to eq('item')
    end

    it "has a name" do
      expect(jacket.name).to eq('jacket')
    end

    it "has an array of performable actions" do
      expect(jacket.actions).to eq(['wear', 'put on'])
    end

    it "knows what PersonNode or RoomNode it belongs to" do
      expect(jacket.location_type).to eq(PersonNode)
      expect(jacket.location_id).to eq(1)
    end
  end

  describe 'WeaponNode' do
    it "has a type of weapon" do
      expect(sword.type).to eq('weapon')
    end

    # the following test inherited methods/attributes
    it "has a name" do
      expect(sword.name).to eq('sword')
    end

    it "has an array of performable actions" do
      expect(sword.actions).to eq(['cut', 'stab'])
    end

    it "knows what PersonNode or RoomNode it belongs to" do
      expect(sword.location_type).to eq(RoomNode)
      expect(sword.location_id).to eq(1)
    end
  end
end
