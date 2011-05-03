require 'singleton'
require 'eat'
require 'active_support'
require 'active_support/version'
%w{
  active_support/core_ext/object
}.each do |active_support_3_requirement|
  require active_support_3_requirement
end if ::ActiveSupport::VERSION::MAJOR >= 3

module BrighterPlanet
  def self.deploy
    Deploy.instance
  end
  
  class Deploy
    include ::Singleton
    
    autoload :Server, 'brighter_planet_deploy/server'
    autoload :EmissionEstimateService, 'brighter_planet_deploy/emission_estimate_service'
    
    # mixins
    autoload :ReadsFromLocalFilesystem, 'brighter_planet_deploy/reads_from_local_filesystem'
    autoload :ReadsFromPublicUrl, 'brighter_planet_deploy/reads_from_public_url'
    
    def servers
      Server
    end
    
    def emission_estimate_service
      EmissionEstimateService.app_master
    end
  end
end
