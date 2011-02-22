require 'spec_helper'

describe Profile do
  
  describe "display name" do
    before(:each) do
      @user = User.new(:email => "test@email.com", :username => "username")
      @profile = Profile.new(:user => @user)
    end
    context "no name" do
      it { @profile.display_name.should == "username" }
    end
    context "use name" do
      before(:each) { @profile.name = "Name" }
      it { @profile.display_name.should == "Name" }
    end
    context "empty name" do
      before(:each) { @profile.name = "" }
      it { @profile.display_name.should == "username" }
    end
  end
  
end
