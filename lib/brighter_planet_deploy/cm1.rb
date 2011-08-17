module BrighterPlanet
  class Deploy
    class Cm1
      include ::Singleton
      include ReadsFromPublicUrl

      RED_IP = '184.73.240.13'

      WANTS = [
        :resque_redis_url,
        :incoming_queue,
        :color,
        :role,
        :environment,
        :log_dir,
        :phase,
        :carrier, # amazon
        :ey_app,  # cm1_edge_blue
        :service
      ]

      def domain
        'carbon.brighterplanet.com'
      end

      def endpoint
        "http://#{domain}"
      end

      def color
        if Deploy.instance.servers.me.service.to_s.underscore == 'cm1'
          (AuthoritativeDnsResolver.getaddress(domain) == RED_IP) ? 'red' : 'blue'
        else
          from_public_url :color
        end
      end

      def method_missing(method_id, *args)
        if args.length == 0 and not block_given?
          from_public_url method_id
        else
          super
        end
      end
    end
  end
end
