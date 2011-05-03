require 'singleton'
require 'eat'

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
      EmissionEstimateService.instance
    end
  end
end
