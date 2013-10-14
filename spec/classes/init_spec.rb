# require 'spec_helper'
require "#{File.join(File.dirname(__config_file__),'..','spec_helper.rb')}"

describe 'memcached' do

  let(:title) { 'memcached' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { {
    :ipaddress => '10.42.42.42',
  } }

  describe 'Test default settings  ' do
    it 'should install memcached package' do should contain_package('memcached').with_ensure('present') end
    it 'should run memcached service' do should contain_service('memcached').with_ensure('running') end
    it 'should enable memcached service at boot' do should contain_service('memcached').with_enable('true') end
    it 'should manage config file presence' do should contain_file('memcached.conf').with_ensure('present') end
  end

  describe 'Test installation of a specific package version' do
    let(:params) { {
      :install => 'package',
      :version => '1.0.42',
    } }
    it { should contain_package('memcached').with_ensure('1.0.42') }
  end

  describe 'Test decommissioning of package installation' do
    let(:params) { {
      :ensure => 'absent',
      :install => 'package',
    } }
    it 'should remove Package[memcached]' do should contain_package('memcached').with_ensure('absent') end
    it 'should stop Service[memcached]' do should contain_service('memcached').with_ensure('stopped') end
    it 'should not manage at boot Service[memcached]' do should contain_service('memcached').with_enable(nil) end
    it 'should remove memcached configuration file' do should contain_file('memcached.conf').with_ensure('absent') end
  end

  describe 'Test service disabling' do
    let(:params) { {
      :service_ensure => 'stopped',
      :service_enable => false,
    } }
    it 'should stop Service[memcached]' do should contain_service('memcached').with_ensure('stopped') end
    it 'should not enable at boot Service[memcached]' do should contain_service('memcached').with_enable('false') end
  end

  describe 'Test custom file via template' do
    let(:params) { {
      :config_file_template => 'memcached/spec/spec.conf.erb',
      :config_file_options_hash => { 'opt_a' => 'value_a' },
    } }
    it { should contain_file('memcached.conf').with_content(/fqdn: rspec.example42.com/) }
    it 'should generate a template that uses custom options' do
      should contain_file('memcached.conf').with_content(/value_a/)
    end
  end

  describe 'Test custom file via source' do
    let(:params) { {:config_file_source => "puppet:///modules/memcached/spec/spec.conf"} }
    it { should contain_file('memcached.conf').with_source('puppet:///modules/memcached/spec/spec.conf') }
  end

  describe 'Test customizations - dir' do
    let(:params) { {
      :config_dir_source => 'puppet:///modules/memcached/tests/',
      :config_dir_purge => true
    } }
    it { should contain_file('memcached.dir').with_source('puppet:///modules/memcached/tests/') }
    it { should contain_file('memcached.dir').with_purge('true') }
    it { should contain_file('memcached.dir').with_force('true') }
  end

  describe 'Test customizations - custom class' do
    let(:params) { {:my_class => "memcached::spec" } }
    it { should contain_file('my_config').with_content(/my_content/) }
    it { should contain_file('my_config').with_path('/etc/memcached/my_config') }
  end

  describe 'Test service subscribe' do
    let(:params) { {:service_subscribe => false } }
    it 'should not automatically restart the service when files change' do
      should contain_service('memcached').with_subscribe(false)
    end
  end

end

