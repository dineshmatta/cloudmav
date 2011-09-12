require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env) if defined?(Bundler)

module Codemav
  class Application < Rails::Application
    config.generators do |g|
      g.template_engine :haml
      g.test_framework  :rspec, :fixture => false
    end
    
    if config.respond_to?(:autoload_paths)
      config.autoload_paths += %W( #{config.root}/app/events ) 
      config.autoload_paths += %W( #{config.root}/lib ) 
    end
    
    config.encoding = "utf-8"
    
    config.action_mailer.default_url_options = { :host => 'www.codemav.com' }

    config.filter_parameters += [:password, :password_confirmation]

    #config.to_prepare do
    #  Devise::SessionsController.ssl_required :new, :create
    #end
  end
end
