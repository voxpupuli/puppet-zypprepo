# frozen_string_literal: true

require 'spec_helper'

describe 'Zypprepo::Rpmarch' do
  it { is_expected.to allow_value('x86_64') }
  it { is_expected.to allow_value('aarch64') }
  it { is_expected.to allow_value('noarch') }
  it { is_expected.not_to allow_values('quantum') }
end
