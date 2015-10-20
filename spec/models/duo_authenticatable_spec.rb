require 'spec_helper'

describe Devise::Models::DuoAuthenticatable do
  before(:each) do
    @user = create_user(:duo_id => '20')
  end

  describe "User#find_by_duo_id" do
    it "Should find the user" do
      User.find_by_duo_id('20').should_not be_nil
    end

    it "Shouldn't find the user" do
      User.find_by_duo_id('80').should be_nil
    end
  end
end
