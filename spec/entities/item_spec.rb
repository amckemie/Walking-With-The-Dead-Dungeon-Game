require 'spec_helper.rb'


  describe 'ItemNode' do
    let(:ashley) {WWTD::PlayerNode.new(id: 1, name: 'Ashley', strength: 100)}
    let(:jacket) {WWTD::ItemNode.new(id: 1, name: 'jacket', type: 'item', description: 'a warm wooly coat', actions: ['wear', 'put on'], location_type: ashley.class, location_id: ashley.id)}
    let(:sword)  {WWTD::ItemNode.new(id: 1, name: 'sword', type: 'weapon', actions: ['cut', 'stab'], location_type: ashley.class, location_id: ashley.id)}

    it "is an ItemNode" do
      expect(jacket.class).to eq(WWTD::ItemNode)
    end

    it "has a name" do
      expect(jacket.name).to eq('jacket')
    end

    it "has a description" do
      expect(jacket.description).to eq('a warm wooly coat')
    end

    it 'has a type' do
      expect(sword.type).to eq('weapon')
      expect(jacket.type).to eq('item')
    end

    it "has an array of performable actions" do
      expect(jacket.actions).to eq(['wear', 'put on'])
    end

    it "knows what PersonNode or RoomNode it belongs to" do
      expect(jacket.location_type).to eq(WWTD::PlayerNode)
      expect(jacket.location_id).to eq(1)
    end
  end

