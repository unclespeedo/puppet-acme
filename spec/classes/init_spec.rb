require 'spec_helper'
describe 'acme' do

  context 'with defaults for all parameters' do
    it { should contain_class('acme') }
  end
end
