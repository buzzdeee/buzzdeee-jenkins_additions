require 'spec_helper'
describe 'jenkins_additions' do

  context 'with defaults for all parameters' do
    it { should contain_class('jenkins_additions') }
  end
end
