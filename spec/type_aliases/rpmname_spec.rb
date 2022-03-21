# frozen_string_literal: true

require 'spec_helper'

describe 'Zypprepo::Rpmname' do
  it { is_expected.to allow_value('python36-foobar') }
  # confirmed that Name: puppet:agent is not permitted
  # rpmbuild -bs ~/rpmbuild/SPECS/puppet\:agent.spec
  # error: line 28: Illegal char ':' (0x3a) in: Name: puppet:agent
  it { is_expected.not_to allow_values('puppet:agent') }
end
