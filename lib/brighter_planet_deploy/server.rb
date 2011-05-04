module BrighterPlanet
  class Deploy
    class Server
      include ReadsFromLocalFilesystem

      class InvalidKey < ::ArgumentError;
      end
      
      # keys that are published
      PUBLIC = [:gender]
      # keys that are not saved
      NOT_SAVED = [:local, :rails_root, :public_dir, :private_dir]

      class << self
        def me
          new :local => true
        end
      end

      def initialize(attrs = {})
        attrs.each do |k, v|
          instance_variable_set "@#{k}", v
        end
      end

      def local?
        !!@local
      end
      
      attr_writer :hostname
      def hostname
        @hostname || lookup(:hostname) || local_hostname
      end

      # can't be saved
      attr_writer :rails_root
      def rails_root
        @rails_root || local_rails_root
      end

      # can't be saved
      attr_writer :public_dir
      def public_dir
        @public_dir || ::File.join(rails_root, 'public')
      end

      # can't be saved
      attr_writer :private_dir
      def private_dir
        @private_dir || ::File.join(rails_root, 'config')
      end

      attr_writer :environment
      def environment
        @environment || lookup(:environment) || local_rails_environment
      end

      attr_writer :status
      def status
        @status || lookup(:status) || (gender == service_class.gender ? :active : :standby)
      end

      def service_class
        case service.to_sym
        when :EmissionEstimateService, :cm1
          EmissionEstimateService.instance
        end
      end

      def method_missing(method_id, *args)
        if method_id.to_s.end_with?('=') and args.length == 1
          instance_variable_set "@#{method_id.to_s.chomp('=')}", args[0]
        elsif args.length == 0 and not block_given?
          lookup method_id
        else
          super
        end
      end

      def public?(k)
        PUBLIC.include? k.to_sym
      end
      
      def not_saved?(k)
        NOT_SAVED.include? k.to_sym
      end

      private

      def lookup(k)
        if public? k
          from_public_dir k
        else
          from_private_dir k
        end
      end

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

      def local_rails_environment
        return unless local?
        if defined?(::Rails) and ::Rails.respond_to?(:env)
          ::Rails.env
        elsif ::ENV.has_key? 'RAILS_ENV'
          ::ENV['RAILS_ENV']
        end
      end
    end
  end
end
