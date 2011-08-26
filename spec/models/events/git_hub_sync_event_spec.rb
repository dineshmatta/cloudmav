require 'spec_helper'

describe "GitHubProfileSyncEvent" do

  describe "sync" do
    before(:each) do
      @profile = Factory.create(:user).profile
      @git_hub_profile = GitHubProfile.new(:username => "rookieone")
      @profile.git_hub_profile = @git_hub_profile
      @git_hub_profile.save
      @git_hub_profile.expects(:retag!)

      event = GitHubProfileSyncEvent.new(:git_hub_profile => @git_hub_profile, :profile => @profile)
      event.subject_class_name = "GitHubProfile"
      event.subject_id = @git_hub_profile.id
      event.profile = @git_hub_profile.profile

      VCR.use_cassette("git_hub_sync_event", :record => :new_episodes) do
        event.save
      end
      @profile = Profile.find(@profile.id)
    end

    it { @git_hub_profile.url.should == "http://www.github.com/rookieone" }
    it { @git_hub_profile.git_hub_id.should_not be_empty }
    it { @git_hub_profile.followers_count.should == 8 }
    it { @git_hub_profile.following_count.should == 4 }
    it { @profile.score(:coder_points).should == 52 }
  end

  describe "jnunemaker sync" do
    before(:each) do
      @profile = Factory.create(:user).profile
      @git_hub_profile = GitHubProfile.new(:username => "jnunemaker")
      @profile.git_hub_profile = @git_hub_profile
      @git_hub_profile.save
      @git_hub_profile.expects(:retag!)

      event = GitHubProfileSyncEvent.new(:git_hub_profile => @git_hub_profile)
      event.subject_class_name = "GitHubProfile"
      event.subject_id = @git_hub_profile.id
      event.profile = @git_hub_profile.profile

      VCR.use_cassette("jnunemaker git_hub_sync_event", :record => :new_episodes) do
        event.save
      end
      @profile = Profile.find(@profile.id)
    end

    it { @git_hub_profile.url.should == "http://www.github.com/jnunemaker" }
    it { @git_hub_profile.git_hub_id.should_not be_empty }
    it { @git_hub_profile.followers_count.should == 749 }
    it { @git_hub_profile.following_count.should == 22 }
    it { @git_hub_profile.repositories.count.should == 42 }
    it { @profile.score(:coder_points).should == 804 }
  end

  describe "chriseppstein sync" do
    before(:each) do
      @profile = Factory.create(:user).profile
      @git_hub_profile = GitHubProfile.new(:username => "chriseppstein")
      @profile.git_hub_profile = @git_hub_profile
      @git_hub_profile.save
      @git_hub_profile.expects(:retag!)
      event = GitHubProfileSyncEvent.new(:git_hub_profile => @git_hub_profile)
      event.subject_class_name = "GitHubProfile"
      event.subject_id = @git_hub_profile.id
      event.profile = @git_hub_profile.profile

      VCR.use_cassette("chriseppstein git_hub_sync_event", :record => :new_episodes) do
        event.save
      end
      @profile = Profile.find(@profile.id)
    end

    it { @git_hub_profile.url.should == "http://www.github.com/chriseppstein" }
    it { @git_hub_profile.git_hub_id.should_not be_empty }
    it { @git_hub_profile.followers_count.should == 287 }
    it { @git_hub_profile.following_count.should == 25 }
    it { @git_hub_profile.repositories.count.should == 26 }
    it { @profile.score(:coder_points).should == 421 }
  end

  
end

