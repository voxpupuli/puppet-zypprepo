# frozen_string_literal: true

require 'spec_helper'

describe 'Zypprepo::Rpmversion' do
  it { is_expected.to allow_value('3.2') }
  it { is_expected.to allow_value('3.2alpha23') }
  it { is_expected.to allow_value('3.2_alpha23') }
  it { is_expected.not_to allow_values('4-3') }
  it { is_expected.not_to allow_values('-3') }
  it { is_expected.not_to allow_values('3-') }
end
