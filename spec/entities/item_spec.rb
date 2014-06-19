require 'spec_helper.rb'


  describe 'ItemNode' do
    let(:ashley) {WWTD::PlayerNode.new(id: 1, name: 'Ashley', strength: 100)}
    let(:jacket) {WWTD::ItemNode.new(id: 1, name: 'jacket', classification: 'item', description: 'a warm wooly coat', actions: ['wear', 'put on'], location_type: ashley.class, location_id: ashley.id)}
    let(:sword)  {WWTD::ItemNode.new(id: 1, name: 'sword', classification: 'weapon', actions: ['cut', 'stab'], location_type: ashley.class, location_id: ashley.id, parent_item: jacket.id)}

    it "is an ItemNode" do
      expect(jacket.class).to eq(WWTD::ItemNode)
    end

    it "has a name" do
      expect(jacket.name).to eq('jacket')
    end

    it "has a description" do
      expect(jacket.description).to eq('a warm wooly coat')
    end

    it 'has a classification' do
      expect(sword.classification).to eq('weapon')
      expect(jacket.classification).to eq('item')
    end

    it "has an array of performable actions" do
      expect(jacket.actions).to eq(['wear', 'put on'])
    end

    # it "knows what PersonNode or RoomNode it belongs to" do
    #   expect(jacket.location_type).to eq(WWTD::PlayerNode)
    #   expect(jacket.location_id).to eq(1)
    # end

    it 'has a parent_item id set to 0 if no parent and the id of another item if it has a parent' do
      expect(jacket.parent_item).to eq(0)
      expect(sword.parent_item).to eq(1)
    end
  end

