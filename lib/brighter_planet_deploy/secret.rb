module BrighterPlanet
  class Deploy
    class Secret
      include ::Singleton

      def method_missing(method_id, *args)
        from_secret method_id
      end
      
      private
      
      def from_secret(id)
        if ::File.readable? '/etc/brighterplanet/secrets.yaml'
          ::YAML.load(::File.read('/etc/brighterplanet/secrets.yaml'))[id.to_s]
        end
      end
    end
  end
end
