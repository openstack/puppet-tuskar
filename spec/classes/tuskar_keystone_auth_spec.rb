#
# Unit tests for tuskar::keystone::auth
#
require 'spec_helper'

describe 'tuskar::keystone::auth' do

  let :facts do
    { :osfamily => 'Debian' }
  end

  describe 'with default class parameters' do
    let :params do
      { :password => 'tuskar_password',
        :tenant   => 'foobar' }
    end

    it { is_expected.to contain_keystone_user('tuskar').with(
      :ensure   => 'present',
      :password => 'tuskar_password',
    ) }

    it { is_expected.to contain_keystone_user_role('tuskar@foobar').with(
      :ensure  => 'present',
      :roles   => ['admin']
    )}

    it { is_expected.to contain_keystone_service('tuskar::management').with(
      :ensure      => 'present',
      :description => 'Tuskar Management Service'
    ) }

    it { is_expected.to contain_keystone_endpoint('RegionOne/tuskar::management').with(
      :ensure       => 'present',
      :public_url   => "http://127.0.0.1:8585",
      :admin_url    => "http://127.0.0.1:8585",
      :internal_url => "http://127.0.0.1:8585"
    ) }
  end

  describe 'with endpoint parameters' do
    let :params do
      { :password     => 'tuskar_password',
        :public_url   => 'https://10.0.0.10:8585',
        :admin_url    => 'https://10.0.0.11:8585',
        :internal_url => 'https://10.0.0.11:8585' }
    end

    it { is_expected.to contain_keystone_endpoint('RegionOne/tuskar::management').with(
      :ensure       => 'present',
      :public_url   => 'https://10.0.0.10:8585',
      :admin_url    => 'https://10.0.0.11:8585',
      :internal_url => 'https://10.0.0.11:8585'
    ) }
  end

  describe 'when configuring tuskar-server' do
    let :pre_condition do
      "class { 'tuskar::server': auth_password => 'test' }"
    end

    let :params do
      { :password => 'tuskar_password',
        :tenant   => 'foobar' }
    end
  end

  describe 'when overriding public_protocol, public_port and public address' do
    let :params do
      { :password         => 'tuskar_password',
        :public_protocol  => 'https',
        :public_port      => '80',
        :public_address   => '10.10.10.10',
        :port             => '81',
        :internal_address => '10.10.10.11',
        :admin_address    => '10.10.10.12' }
    end

    it { is_expected.to contain_keystone_endpoint('RegionOne/tuskar::management').with(
      :ensure       => 'present',
      :public_url   => "https://10.10.10.10:80",
      :internal_url => "http://10.10.10.11:81",
      :admin_url    => "http://10.10.10.12:81"
    ) }
  end

  describe 'when overriding auth name' do
    let :params do
      { :password => 'foo',
        :auth_name => 'tuskary' }
    end

    it { is_expected.to contain_keystone_user('tuskary') }
    it { is_expected.to contain_keystone_user_role('tuskary@services') }
    it { is_expected.to contain_keystone_service('tuskary::management') }
    it { is_expected.to contain_keystone_endpoint('RegionOne/tuskary::management') }
  end

  describe 'when overriding various parameters' do
    let :params do
      { :password            => 'foo',
        :service_name        => 'mytuskar',
        :configure_user      => false,
        :configure_user_role => false }
    end

    it { is_expected.to contain_keystone__resource__service_identity('tuskar').with(
      :service_name        => 'mytuskar',
      :configure_user      => false,
      :configure_user_role => false,
    ) }
  end

end
