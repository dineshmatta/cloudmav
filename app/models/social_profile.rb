class SocialProfile
  include Mongoid::Document
  include Mongoid::Timestamps
  include CodeMav::Taggable
  
  belongs_to :profile

  def related_items
    [profile]
  end
  
  def generate_tags
  end

end

