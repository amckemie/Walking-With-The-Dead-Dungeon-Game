require 'spec_helper'

describe WWTD::Person do
  describe 'eat' do
    it "increases a person's strength by the amount that specific food gives" do
      apple = WWTD::Item('apple')
      person = WWTD::Person("ashley", 100)
    end

    it "doesn't increase a person's strength past 100" do
    end

    it "removes the food from the person's inventory" do
    end
  end

  describe 'drink' do
    it "increase a person's strength by the drink's strength percentage" do
    end

    it "removes the drink from the person's inventory" do
    end
  end

  describe 'rest' do
  end
end
