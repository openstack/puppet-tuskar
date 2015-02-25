require 'spec_helper'

describe 'tuskar::db::postgresql' do

  let :req_params do
    {:password => 'pw'}
  end

  let :facts do
    {
      :postgres_default_version => '8.4',
      :osfamily => 'RedHat',
    }
  end

  describe 'with only required params' do
    let :params do
      req_params
    end
    it { is_expected.to contain_postgresql__db('tuskar').with(
      :user         => 'tuskar',
      :password     => 'pw'
     ) }
  end

end
