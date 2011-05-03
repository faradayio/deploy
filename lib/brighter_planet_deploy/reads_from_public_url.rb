module BrighterPlanet
  class Deploy
    module ReadsFromPublicUrl
      def from_public_url(id)
        eat "#{endpoint}/brighter_planet_deploy/#{id}"
      end
    end
  end
end
