require 'spec_helper'

describe 'memcached' do
  context 'supported operating systems' do
    ['Debian', 'RedHat'].each do |osfamily|
      describe "memcached class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily => osfamily,
        }}

        it { should include_class('memcached::params') }

        it { should contain_class('memcached::install') }
        it { should contain_class('memcached::config') }
        it { should contain_class('memcached::service') }
      end
    end
  end

  context 'unsupported operating system' do
    describe 'memcached class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { should }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
