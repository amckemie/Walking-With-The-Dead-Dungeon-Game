require 'spec_helper.rb'


  describe 'ItemNode' do
    let(:ashley) {WWTD::PlayerNode.new(id: 1, name: 'Ashley', strength: 100)}
    let(:jacket) {WWTD::ItemNode.new(id: 1, name: 'jacket', classification: 'item', description: 'a warm wooly coat', actions: ['wear', 'put on'], room_id: 1)}
    let(:sword)  {WWTD::ItemNode.new(id: 1, name: 'sword', classification: 'weapon', actions: ['cut', 'stab'], parent_item: jacket.id)}

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

    it 'has a room_id that is set to the room it is in or nil if it is in a persons possession or gone from the game' do
      expect(jacket.room_id).to_not be_nil
      expect(sword.room_id).to be_nil
    end

    it 'has a parent_item id set to 0 if no parent and the id of another item if it has a parent' do
      expect(jacket.parent_item).to eq(0)
      expect(sword.parent_item).to eq(1)
    end
  end

