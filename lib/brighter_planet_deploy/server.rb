module BrighterPlanet
  class Deploy
    class Server
      include ReadsFromLocalFilesystem
      
      class << self
        def me
          new :hostname => `hostname -f`.chomp, :local => true
        end
      end
        
      attr_reader :hostname
    
      def initialize(attrs = {})
        attrs.each do |k, v|
          if respond_to? "#{k}="
            send "#{k}=", v
          else
            instance_variable_set "@#{k}", v
          end
        end
      end

      delegate :status, :to => :service
      delegate :resque_redis_url, :to => :service
      
      def local?
        !!@local
      end
      
      def public_dir
        from_etc :public_dir
      end
      
      def gender
        from_public_dir(:gender).to_sym
      end
            
      def service
        case from_public_dir(:service).to_sym
        when :cm1, :EmissionEstimateService
          EmissionEstimateService.new self
        end
      end
    end
  end
end
