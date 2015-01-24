require 'spec_helper'

describe 'munin::snmp_target', :type => 'define' do


  context 'with snmp v1 target' do
      include_context :Debian
      let(:title) { 'networkdevice' }
      let (:host) { 'networkdevice' }
      let (:params) {
        { :snmp_version => 1,
          :snmp_community => 'default' }
      }

      it {
        should contain_file('/etc/munin/plugin-conf.d/snmp_networkdevice.conf').with_ensure('present')
      }
  end

  context 'with snmp v2 target' do
    include_context :Debian
    let(:title) { 'networkdevice_v2c' }
    let (:host) { 'networkdevice_v2c' }
    let (:params) {
      { :snmp_version => '2c',
        :snmp_community => 'default' }
    }

    it {
      should contain_file('/etc/munin/plugin-conf.d/snmp_networkdevice_v2c.conf').with_ensure('present')
    }
  end

  context 'with snmp v3 target' do
    include_context :Debian
    let(:title) { 'networkdevice_v3' }
    let (:host) { 'networkdevice_v3' }
    let (:params) {
      { :snmp_version => 3,
        :snmp_community => 'default' }
    }

    it {
      should contain_file('/etc/munin/plugin-conf.d/snmp_networkdevice_v3.conf').with_ensure('present')
    }
  end
end
