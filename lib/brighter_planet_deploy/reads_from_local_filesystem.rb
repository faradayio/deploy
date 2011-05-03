require 'fileutils'
module BrighterPlanet
  class Deploy
    module ReadsFromLocalFilesystem
      class NotLocal < ::RuntimeError;
      end
      
      class NotFound < ::RuntimeError;
      end
            
      def from_private_dir(id)
        from_file private_brighter_planet_deploy_path(id)
      end
      
      def from_public_dir(id)
        from_file public_brighter_planet_deploy_path(id)
      end
      
      def write_config(config = {})
        [ :public, :private ].each do |loc|
          config[loc].each do |k, v|
            path = send("#{loc}_brighter_planet_deploy_path", k)
            $stderr.puts "[brighter_planet_deploy] Writing #{k}=#{v} to #{path}"
            ::FileUtils.mkdir_p ::File.dirname(path)
            ::File.open(path, 'w') { |f| f.write v.to_s }
          end
        end
      end
      
      def save_config
        public = self.class.const_get(:PUBLIC).inject({}) do |memo, k|
          if v = instance_variable_get("@#{k}")
            memo[k] = v
          end
          memo
        end
        private = self.class.const_get(:PRIVATE).inject({}) do |memo, k|
          if v = instance_variable_get("@#{k}")
            memo[k] = v
          end
          memo
        end
        write_config :public => public, :private => private
      end
      
      private

      def public_brighter_planet_deploy_path(id)
        dir = ::File.join public_dir, 'brighter_planet_deploy', id.to_s
        ::FileUtils.mkdir_p dir unless ::File.directory? dir
        dir
      end
      
      def private_brighter_planet_deploy_path(id)
        dir = ::File.join private_dir, 'brighter_planet_deploy', id.to_s
        ::FileUtils.mkdir_p dir unless ::File.directory? dir
        dir
      end
      
      # fills placeholders like [STATUS] by sending :status
      def from_file(path)
        raise NotLocal, "[brighter_planet_deploy] Can't read #{path} unless this is being run on the server" unless local?
        raise NotFound, "[brighter_planet_deploy] Can't read #{path} on this server" unless ::File.readable? path
        str = ::File.readlines(path)[0].chomp
        str.dup.scan(%r{\[([^\]]+)\]}) do |placeholder|
          placeholder = placeholder[0]
          if respond_to?(placeholder.downcase) and v = send(placeholder.downcase)
            str.gsub! "[#{placeholder}]", v.to_s
          end
        end
        str
      end
    end
  end
end
