module BrighterPlanet
  class Deploy
    module ReadsFromLocalFilesystem
      class NotLocal < ::RuntimeError;
      end
      
      class NotFound < ::RuntimeError;
      end
            
      def from_etc(id)
        from_file etc_brighter_planet_deploy_path(id)
      end
      
      def from_public_dir(id)
        from_file public_brighter_planet_deploy_path(id)
      end
      
      def write_config(config = {})
        [ :public, :etc ].each do |loc|
          config[loc].each do |k, v|
            path = send("#{loc}_brighter_planet_deploy_path", k)
            $stderr.puts "[brighter_planet_deploy] Writing #{k}=#{v} to #{path}"
            ::FileUtils.mkdir_p ::File.dirname(path)
            ::File.open(path, 'w') { |f| f.write v.to_s }
          end
        end
      end

      private

      def public_brighter_planet_deploy_path(id)
        ::File.join public_dir, 'brighter_planet_deploy', id
      end
      
      def etc_brighter_planet_deploy_path(id)
        ::File.join '/etc/brighter_planet_deploy', id
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
