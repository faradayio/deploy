module BrighterPlanet
  class Deploy
    module ReadsFromLocalFilesystem
      class NotLocal < ::RuntimeError;
      end
      
      class NotFound < ::RuntimeError;
      end
      
      def etc_dir
        '/etc/brighter_planet_deploy'
      end
      
      def public_dir
        from_etc :public_dir
      end
      
      def from_etc(id, fill = {})
        from_file ::File.join(etc_dir, id), fill
      end
      
      def from_public_dir(id, fill = {})
        from_file ::File.join(public_dir, 'brighter_planet_deploy', id), fill
      end

      private
      
      def from_file(path, fill)
        raise NotLocal, "[brighter_planet_deploy] Can't read #{path} unless this is being run on the server" unless local?
        raise NotFound, "[brighter_planet_deploy] Can't read #{path} on this server" unless ::File.readable? path
        str = ::File.readlines(path)[0].chomp
        fill.each do |k, v|
          str.gsub! "[#{k.to_s.upcase}]", v.to_s
        end
        str
      end
    end
  end
end
