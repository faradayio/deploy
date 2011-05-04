require 'net/dns/resolver'
module BrighterPlanet
  class Deploy
    class AuthoritativeDnsResolver
      # sabshere 5/4/11 last updated
      NAMESERVERS = {
        'ns1.easydns.com' => '66.225.199.10',
        'ns2.easydns.com' => '72.52.2.1',
      }
      
      class << self
        def getaddress(domain)
          new(domain).getaddress
        end
      end
      
      attr_reader :domain
      
      def initialize(domain)
        @domain = domain
      end
      
      def getaddress
        resolver = ::Net::DNS::Resolver.new :nameservers => NAMESERVERS.values, :use_tcp => false, :config_file => empty_config_file_path
        packet = resolver.search domain, ::Net::DNS::A, ::Net::DNS::IN
        packet.answer[0].address.to_s
      end
      
      # net-dns always looks for this, so give it something empty
      def empty_config_file_path
        ::File.expand_path '../../../support/empty_resolv.conf', __FILE__
      end
    end
  end
end
