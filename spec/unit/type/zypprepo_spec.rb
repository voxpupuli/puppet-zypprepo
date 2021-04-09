require 'spec_helper'
require 'puppet'

shared_examples_for 'a zypprepo parameter that can be absent' do |param|
  it 'can be set as :absent' do
    described_class.new(:name => 'puppetlabs', param => :absent)
  end
  it 'can be set as "absent"' do
    described_class.new(:name => 'puppetlabs', param => 'absent')
  end
end

shared_examples_for 'a zypprepo parameter that can be an integer' do |param|
  it 'accepts a valid positive integer' do
    instance = described_class.new(:name => 'puppetlabs', param => '12')
    expect(instance[param]).to eq '12'
  end
  it 'accepts zero' do
    instance = described_class.new(:name => 'puppetlabs', param => '0')
    expect(instance[param]).to eq '0'
  end
  it 'rejects invalid positive float' do
    expect do
      described_class.new(
        :name => 'puppetlabs',
        param => '12.5'
      )
    end.to raise_error(Puppet::ResourceError, %r{Parameter #{param} failed})
  end
  it 'rejects invalid non-integer' do
    expect do
      described_class.new(
        :name => 'puppetlabs',
        param => 'I\'m a six'
      )
    end.to raise_error(Puppet::ResourceError, %r{Parameter #{param} failed})
  end
  it 'rejects invalid string with integers inside' do
    expect do
      described_class.new(
        :name => 'puppetlabs',
        param => 'I\'m a 6'
      )
    end.to raise_error(Puppet::ResourceError, %r{Parameter #{param} failed})
  end
end

shared_examples_for "a zypprepo parameter that can't be a negative integer" do |param|
  it 'rejects invalid negative integer' do
    expect do
      described_class.new(
        :name => 'puppetlabs',
        param => '-12'
      )
    end.to raise_error(Puppet::ResourceError, %r{Parameter #{param} failed})
  end
end

shared_examples_for 'a zypprepo parameter that expects a boolean parameter' do |param|
  valid_values = %w[true false 0 1 no yes]

  valid_values.each do |value|
    it "accepts #{value} downcased to #{value.downcase} and capitalizes it" do
      instance = described_class.new(:name => 'puppetlabs', param => value.downcase)
      expect(instance[param]).to eq value.downcase.capitalize
    end
    it "fails on valid value #{value} contained in another value" do
      expect do
        described_class.new(
          :name => 'puppetlabs',
          param => "bla#{value}bla"
        )
      end.to raise_error(Puppet::ResourceError, %r{Parameter #{param} failed})
    end
  end

  it 'rejects invalid boolean values' do
    expect do
      described_class.new(:name => 'puppetlabs', param => 'flase')
    end.to raise_error(Puppet::ResourceError, %r{Parameter #{param} failed})
  end
end

shared_examples_for 'a zypprepo parameter that accepts a single URL' do |param|
  it 'can accept a single URL' do
    described_class.new(
      :name => 'puppetlabs',
      param => 'http://localhost/zypprepos'
    )
  end

  it 'fails if an invalid URL is provided' do
    expect do
      described_class.new(
        :name => 'puppetlabs',
        param => "that's no URL!"
      )
    end.to raise_error(Puppet::ResourceError, %r{Parameter #{param} failed})
  end

  it 'fails if a valid URL uses an invalid URI scheme' do
    expect do
      described_class.new(
        :name => 'puppetlabs',
        param => 'ldap://localhost/zypprepos'
      )
    end.to raise_error(Puppet::ResourceError, %r{Parameter #{param} failed})
  end
end

shared_examples_for 'a zypprepo parameter that accepts multiple URLs' do |param|
  it 'can accept multiple URLs' do
    described_class.new(
      :name => 'puppetlabs',
      param => 'http://localhost/zypprepos http://localhost/more-zypprepos'
    )
  end

  it 'fails if multiple URLs are given and one is invalid' do
    expect do
      described_class.new(
        :name => 'puppetlabs',
        param => "http://localhost/zypprepos That's no URL!"
      )
    end.to raise_error(Puppet::ResourceError, %r{Parameter #{param} failed})
  end
end

shared_examples_for 'a zypprepo parameter that accepts kMG units' do |param|
  %w[k M G].each do |unit|
    it "can accept an integer with #{unit} units" do
      described_class.new(
        :name => 'puppetlabs',
        param => "123#{unit}"
      )
    end
  end

  it 'fails if wrong unit passed' do
    expect do
      described_class.new(
        :name => 'puppetlabs',
        param => '123J'
      )
    end.to raise_error(Puppet::ResourceError, %r{Parameter #{param} failed})
  end
end

describe Puppet::Type.type(:zypprepo) do
  it 'has :name as its namevar' do
    expect(described_class.key_attributes).to eq [:name]
  end

  describe 'validating' do
    describe 'name' do
      it 'is a valid parameter' do
        instance = described_class.new(name: 'puppetlabs')
        expect(instance.name).to eq 'puppetlabs'
      end
    end

    describe 'baseurl' do
      it_behaves_like 'a zypprepo parameter that can be absent', :baseurl
      it_behaves_like 'a zypprepo parameter that accepts a single URL', :baseurl
      it_behaves_like 'a zypprepo parameter that accepts multiple URLs', :baseurl
    end

    describe 'enabled' do
      it_behaves_like 'a zypprepo parameter that expects a boolean parameter', :enabled
      it_behaves_like 'a zypprepo parameter that can be absent', :enabled
    end

    describe 'gpgcheck' do
      it_behaves_like 'a zypprepo parameter that expects a boolean parameter', :gpgcheck
      it_behaves_like 'a zypprepo parameter that can be absent', :gpgcheck
    end

    describe 'repo_gpgcheck' do
      it_behaves_like 'a zypprepo parameter that expects a boolean parameter', :repo_gpgcheck
      it_behaves_like 'a zypprepo parameter that can be absent', :repo_gpgcheck
    end

    describe 'pkg_gpgcheck' do
      it_behaves_like 'a zypprepo parameter that expects a boolean parameter', :pkg_gpgcheck
      it_behaves_like 'a zypprepo parameter that can be absent', :pkg_gpgcheck
    end

    describe 'priority' do
      it_behaves_like 'a zypprepo parameter that can be absent', :priority
      it_behaves_like 'a zypprepo parameter that can be an integer', :priority
    end
  end
end
