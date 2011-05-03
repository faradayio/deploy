module BrighterPlanet
  class Deploy
    class Server
      include ReadsFromLocalFilesystem
      
      class << self
        def me
          new :local => true
        end
      end
    
      def initialize(attrs = {})
        attrs.each do |k, v|
          if respond_to? "#{k}="
            send "#{k}=", v
          else
            instance_variable_set "@#{k}", v
          end
        end
      end

      def local?
        !!@local
      end
      
      attr_writer :rails_root
      def rails_root
        @rails_root || local_rails_root
      end
      
      attr_writer :hostname
      def hostname
        @hostname || local_hostname
      end
      
      attr_writer :public_dir
      def public_dir
        @public_dir || ::File.join(rails_root, 'public')
      end
      
      attr_writer :private_dir
      def private_dir
        @private_dir || ::File.join(rails_root, 'config')
      end
      
      attr_writer :gender
      def gender
        @gender || from_public_dir(:gender).to_sym
      end
      
      attr_writer :phase
      def phase
        @phase || from_public_dir(:phase).to_sym
      end
      
      attr_writer :service
      def service
        @service || from_public_dir(:service).to_sym
      end
            
      attr_writer :resque_redis_url
      def resque_redis_url
        @resque_redis_url || from_private(:resque_redis_url)
      end
      
      attr_writer :status
      def status
        @status || if gender == service_class.gender
          :active
        else
          :standby
        end
      end
      
      def service_class
        case service
        when :EmissionEstimateService, :cm1
          EmissionEstimateService.instance
        end
      end
      
      private
      
      def local_hostname
        return unless local?
        `hostname -f`.chomp
      end
      
      def local_rails_root
        return unless local?
        if defined?(::Rails) and ::Rails.respond_to?(:root)
          ::Rails.root
        elsif ::ENV.has_key? 'RAILS_ROOT'
          ::ENV['RAILS_ROOT']
        end
      end
    end
  end
end
