require 'fileutils'
module BrighterPlanet
  class Deploy
    module ReadsFromLocalFilesystem
      class NotLocal < ::RuntimeError;
      end
      
      def from_private_dir(k)
        from_file private_brighter_planet_deploy_path(k)
      end
      
      def from_public_dir(k)
        from_file public_brighter_planet_deploy_path(k)
      end
      
      def write(config = {})
        [ :public, :private ].each do |loc|
          config[loc].each do |k, v|
            path = send("#{loc}_brighter_planet_deploy_path", k)
            $stderr.puts "[brighter_planet_deploy] Writing #{k}=#{v} to #{path}"
            ::File.open(path, 'w') { |f| f.write v.to_s }
          end
        end
      end
      
      def save
        public = {}
        private = {}
        instance_variables.each do |k|
          k1 = k.to_s.sub('@', '').to_sym
          next if not_saved? k1
          if v = instance_variable_get(k)
            if public? k1
              public[k1] = v
            else
              private[k1] = v
            end
          end
        end
        write :public => public, :private => private
      end
      
      private

      def public_brighter_planet_deploy_path(k)
        p = ::File.join public_dir, 'brighter_planet_deploy', k.to_s
        ::FileUtils.mkdir_p ::File.dirname(p)
        p
      end
      
      def private_brighter_planet_deploy_path(k)
        p = ::File.join private_dir, 'brighter_planet_deploy', k.to_s
        ::FileUtils.mkdir_p ::File.dirname(p)
        p
      end
      
      # fills placeholders like [STATUS] by sending :status
      def from_file(path)
        raise NotLocal, "[brighter_planet_deploy] Can't read #{path} unless this is being run on the server" unless local?
        return unless ::File.readable? path
        str = ::File.readlines(path)[0].chomp
        str.dup.scan(%r{\[([^\]]+)\]}) do |placeholder|
          placeholder = placeholder[0]
          if v = send(placeholder.downcase)
            str.gsub! "[#{placeholder}]", v.to_s
          end
        end
        str
      end
    end
  end
end
