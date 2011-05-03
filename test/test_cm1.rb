require 'helper'

class TestCm1 < Test::Unit::TestCase
  def setup
    FakeWeb.clean_registry
    FakeWeb.allow_net_connect = false
    {
      'http://carbon.brighterplanet.com/brighter_planet_deploy/gender' => 'girl',
    }.each do |url, body|
      FakeWeb.register_uri :get, url, :status => ["200", "OK"], :body => body
    end
    FakeFS.activate!
    FileUtils.mkdir_p '/etc/brighter_planet_deploy'
    File.open('/etc/brighter_planet_deploy/public_dir', 'w') { |f| f.write '/data/edge/current/public' }
    File.open('/etc/brighter_planet_deploy/resque_redis_url', 'w') { |f| f.write "redis://username:password@hostname.redistogo.com:9000/[STATUS]:resque" }
    FileUtils.mkdir_p '/data/edge/current/public/brighter_planet_deploy'
    File.open('/data/edge/current/public/brighter_planet_deploy/service', 'w') { |f| f.write 'cm1' }
    File.open('/data/edge/current/public/brighter_planet_deploy/gender', 'w') { |f| f.write 'girl' }
  end
  
  def teardown
    FakeWeb.clean_registry
    FakeWeb.allow_net_connect = true
    FakeFS.deactivate!
  end
  
  def test_001_gender
    assert_equal :girl, BrighterPlanet.deploy.servers.me.gender
    assert_equal :girl, BrighterPlanet.deploy.emission_estimate_service.gender
  end
    
  def test_003_service
    assert_equal 'EmissionEstimateService', BrighterPlanet.deploy.emission_estimate_service.name
    assert_equal 'EmissionEstimateService', BrighterPlanet.deploy.servers.me.service.name
  end
  
  def test_004_status
    assert_equal :active, BrighterPlanet.deploy.servers.me.status
  end
  
  def test_005_resque_redis_url
    assert BrighterPlanet.deploy.servers.me.resque_redis_url.start_with?('redis://')
    assert BrighterPlanet.deploy.servers.me.resque_redis_url.include?('active')
  end
end
