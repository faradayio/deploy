module BrighterPlanet
  class Deploy
    module ReadsFromPublicUrl
      def from_public_url(k)
        eat "#{endpoint}/brighter_planet_deploy/#{k}"
      end
    end
  end
end
