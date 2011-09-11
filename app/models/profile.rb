class Profile
  include Mongoid::Document
  include Mongoid::Timestamps
  include CodeMav::Autodiscoverable
  
  field :name, :type => String
  field :email, :type => String
  field :username, :type => String
  
  index :username, :unique => true
  
  belongs_to :user
  
  scope :by_username, lambda { |uname| where(:username => uname) }
  scope :named, lambda { |name| { :where => { :name => name } } }
  
  def display_name
    (self.name.blank? || self.name.nil?) ? self.username : self.name
  end
  
  def to_param
    username
  end
  
end