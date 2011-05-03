module BrighterPlanet
  class Deploy
    class EmissionEstimateService
      include ReadsFromLocalFilesystem
      include ReadsFromPublicUrl
      
      class << self
        def app_master
          new Server.new(:hostname => 'carbon.brighterplanet.com')
        end
      end
      
      attr_reader :server
      
      def initialize(server)
        @server = server
      end
      
      delegate :local?, :to => :server
      delegate :public_dir, :to => :server
      
      def endpoint
        'http://carbon.brighterplanet.com'
      end
      
      def gender
        from_public_url(:gender).to_sym
      end
      
      def name
        'EmissionEstimateService'
      end
            
      def status
        if server.gender == gender
          :active
        else
          :standby
        end
      end
      
      def resque_redis_url
        from_etc :resque_redis_url
      end
    end
  end
end
