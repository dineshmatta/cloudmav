class TwitterProfilesController < LoggedInController
  
  def new
    authorize! :sync_profile, @profile
    @twitter_profile = TwitterProfile.new
  end
  
  def create
    authorize! :sync_profile, @profile
    @twitter_profile = TwitterProfile.new(params[:twitter_profile])
    @twitter_profile.profile = @profile
    @twitter_profile.sync!
        
    redirect_to profile_social_path(@profile)
  end

  def edit
    authorize! :sync_profile, @profile
    @twitter_profile = @profile.twitter_profile
  end

  def update
    authorize! :sync_profile, @profile
    
    if @profile.twitter_profile.update_attributes(params[:twitter_profile])
      @profile.twitter_profile.sync!
      redirect_to profile_social_path(@profile)
    else
      render :edit
    end
  end

end
