require 'spec_helper.rb'

describe 'Quest Progress' do
  let(:quest_progress) {WWTD::QuestProgress.new(player_id: 1, quest_id: 1, complete: false, data: {answer_phone: false, enter_lr: false})}

  it 'has a player id that is not nil' do
    expect(quest_progress.player_id).to_not be_nil
  end

  it 'has a quest id that is not nil' do
    expect(quest_progress.quest_id).to_not be_nil
  end

  it 'has a complete status set to a boolean value' do
    expect(quest_progress.complete).to be_false
  end

  it 'has a data hash attribute' do
    expect(quest_progress.data).to be_a(Hash)
    expect(quest_progress.data[:answer_phone]).to eq(false)
    expect(quest_progress.data[:enter_lr]).to eq(false)
  end
end
