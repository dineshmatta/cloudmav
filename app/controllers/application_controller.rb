class ApplicationController < ActionController::Base
  include SslRequirement
  protect_from_forgery
  before_filter :get_guidance
  before_filter :unseen_badges

  helper :all
  helper_method :current_profile
  
  rescue_from CanCan::AccessDenied, :with => :access_denied
  rescue_from RSolr::RequestError, :with => :solr_error
  rescue_from Mongoid::Errors::DocumentNotFound, :with => :document_not_found
  rescue_from BSON::InvalidObjectId, :with => :document_not_found
  
  def current_profile
    return nil if current_user.nil?
    current_user.profile
  end
  
  def geocode(location)
    MultiGeocoder.geocode(location)
  end
  
  def get_guidance
    return if current_user.nil?
    @guidance = current_profile.get_guidance
  end

  def after_sign_in_path_for(user)
    if current_user.profile.autodiscovered?
      profile_url(current_user.profile, :protocol => 'http')
    else
      profile_autodiscovers_url(current_user.profile, :protocol => 'http')
    end
  end

  def after_sign_out_path_for(user)
    root_url(:protocol => 'http')
  end
  
  private 
    def set_profile
      username = params[:username] || params[:profile_id]
      @profile = Profile.by_username(username).first
    end
    
    def set_date(model, param_name)
      date = Date.strptime(params[param_name], '%m/%d/%Y')
      model.send("#{param_name.to_s}=", date)
    end

    def get_datetime(date_param, time_param)
      date = Date.strptime(date_param, '%m/%d/%Y')
      DateTime.parse("#{date.to_s} #{time_param}")
    end
    
    def access_denied
      flash[:error] = "Not authorized to perform that action"
      redirect_to root_path
    end

    def solr_error
      
    end
    
    def unseen_badges
      return unless current_user
      unseen_badgings = current_profile.badgings.unseen.to_a
      @unseen_badges = unseen_badgings.map(&:badge)
      unseen_badgings.each {|b| b.mark_as_seen }
    end

    def document_not_found
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    end
end
