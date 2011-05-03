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
      
      def public_dir
        ::File.join rails_root, 'public'
      end
      
      def private_dir
        ::File.join rails_root, 'config'
      end
      
      def gender
        from_public_dir(:gender).to_sym
      end
      
      def phase
        from_public_dir(:phase).to_sym
      end
            
      def service
        case from_public_dir(:service).to_sym
        when :cm1, :EmissionEstimateService
          EmissionEstimateService.instance
        end
      end
      
      def resque_redis_url
        from_private :resque_redis_url
      end
      
      def status
        if gender == service.gender
          :active
        else
          :standby
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
