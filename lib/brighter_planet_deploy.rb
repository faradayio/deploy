require 'singleton'
require 'eat'

module BrighterPlanet
  def self.deploy
    Deploy.instance
  end
  
  class Deploy
    include ::Singleton
    
    autoload :Server, 'brighter_planet_deploy/server'
    autoload :Cm1, 'brighter_planet_deploy/cm1'
    autoload :AuthoritativeDnsResolver, 'brighter_planet_deploy/authoritative_dns_resolver'
    
    # mixins
    autoload :ReadsFromLocalFilesystem, 'brighter_planet_deploy/reads_from_local_filesystem'
    autoload :ReadsFromPublicUrl, 'brighter_planet_deploy/reads_from_public_url'
    
    def servers
      Server
    end
    
    def cm1
      Cm1.instance
    end
  end
end
