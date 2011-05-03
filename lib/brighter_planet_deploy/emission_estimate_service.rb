module BrighterPlanet
  class Deploy
    class EmissionEstimateService
      include ::Singleton
      include ReadsFromPublicUrl
      
      def endpoint
        'http://carbon.brighterplanet.com'
      end

      def name
        'EmissionEstimateService'
      end
      
      def gender
        from_public_url(:gender).to_sym
      end
    end
  end
end
