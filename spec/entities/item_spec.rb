require 'spec_helper.rb'


  describe 'ItemNode' do
    let(:ashley) {WWTD::PlayerNode.new(id: 1, name: 'Ashley', strength: 100)}
    let(:jacket) {WWTD::ItemNode.new(id: 1, name: 'jacket', description: 'a warm wooly coat', actions: ['wear', 'put on'], location_type: ashley.class, location_id: ashley.id)}

    it "it an ItemNode" do
      expect(jacket.class).to eq(WWTD::ItemNode)
    end

    it "has a name" do
      expect(jacket.name).to eq('jacket')
    end

    it "has a description" do
      expect(jacket.description).to eq('a warm wooly coat')
    end

    it "has an array of performable actions" do
      expect(jacket.actions).to eq(['wear', 'put on'])
    end

    it "knows what PersonNode or RoomNode it belongs to" do
      expect(jacket.location_type).to eq(WWTD::PersonNode)
      expect(jacket.location_id).to eq(1)
    end
  end

  describe 'WeaponNode' do
    before(:each) do
      @bedroom = WWTD::RoomNode.new(id: 1, name: 'Bedroom', description: 'A bedroom', items: [1])
      @sword = WWTD::WeaponNode.new(id: 1, name: 'sword', actions: ['cut', 'stab'], location_type: @bedroom.class, location_id: @bedroom.id)
    end

    it "is a WeaponNode" do
      expect(@sword.class).to eq(WWTD::WeaponNode)
    end

    # the following test inherited methods/attributes
    it "has a name" do
      expect(@sword.name).to eq('sword')
    end

    it "has an array of performable actions" do
      expect(@sword.actions).to eq(['cut', 'stab'])
    end

    it "knows what PersonNode or RoomNode it belongs to" do
      expect(@sword.location_type).to eq(WWTD::RoomNode)
      expect(@sword.location_id).to eq(1)
    end
  end
