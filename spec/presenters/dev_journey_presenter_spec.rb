require 'spec_helper'

describe DevJourneyPresenter do
  before(:each) do
    @profile = Factory.create(:user).profile
  end
  
  describe "get data" do
    context "One job" do
      before(:each) do
        sd = DateTime.parse("10/1/2010")
        ed = DateTime.parse("30/5/2010")
        job = Job.create(:start_date => sd, :end_date => ed)
        @profile.earn_skill(100, "ruby", :coder, "for job", job)
        @data = DevJourneyPresenter.get_data(@profile)
      end
      it { @data[0][:name].should == "ruby" }
      it "should have the data" do
        @data[0][:data].should == [
        {:date=>"01/01/2010", :score=>20}, 
        {:date=>"02/01/2010", :score=>20}, 
        {:date=>"03/01/2010", :score=>20}, 
        {:date=>"04/01/2010", :score=>20}, 
        {:date=>"05/01/2010", :score=>20}
        ]
      end      
    end
    
    context "Two jobs" do
      before(:each) do
        job = Job.create(:start_date => DateTime.parse("10/1/2010"), :end_date => DateTime.parse("30/5/2010"))
        @profile.earn_skill(100, "ruby", :coder, "for job", job)
        
        job = Job.create(:start_date => DateTime.parse("1/4/2010"), :end_date => DateTime.parse("30/9/2010"))
        @profile.earn_skill(100, "ruby", :coder, "for job", job)
        
        @data = DevJourneyPresenter.get_data(@profile)
      end
      it { @data[0][:name].should == "ruby" }
      it "should have the data" do
        @data[0][:data].should == [
          {:date=>"01/01/2010", :score=>20}, 
          {:date=>"02/01/2010", :score=>20}, 
          {:date=>"03/01/2010", :score=>20}, 
          {:date=>"04/01/2010", :score=>36}, 
          {:date=>"05/01/2010", :score=>36}, 
          {:date=>"06/01/2010", :score=>16}, 
          {:date=>"07/01/2010", :score=>16}, 
          {:date=>"08/01/2010", :score=>16}, 
          {:date=>"09/01/2010", :score=>16}
          ]
      end
    end
  end
  
end