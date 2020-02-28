require 'spec_helper'

shared_examples 'a well-defined versionlock' do
  it { is_expected.to compile.with_all_deps }
  it { is_expected.to contain_class('zypprepo::plugin::versionlock') }
end

describe 'zypprepo::versionlock' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with a simple, well-formed title' do
        let(:title) { 'bash-4.4-9.10.1.x86_64' }

        it_behaves_like 'a well-defined versionlock'
        it 'contains a well-formed Concat::Fragment' do
          is_expected.to contain_concat__fragment("zypprepo-versionlock-#{title}").with_content(
            "\ntype: package\n" \
            "match_type: glob\n" \
            "case_sensitive: on\n" \
            "solvable_name: #{title}\n"
          )
        end
      end

      context 'with a trailing wildcard title' do
        let(:title) { 'bash-4.4-9.10.1.*' }

        it_behaves_like 'a well-defined versionlock'
        it 'contains a well-formed Concat::Fragment' do
          is_expected.to contain_concat__fragment("zypprepo-versionlock-#{title}").with_content(
            "\ntype: package\n" \
            "match_type: glob\n" \
            "case_sensitive: on\n" \
            "solvable_name: #{title}\n"
          )
        end
      end

      context 'with a complex wildcard title' do
        let(:title) { 'bash-4.*-*.1' }

        it_behaves_like 'a well-defined versionlock'
        it 'contains a well-formed Concat::Fragment' do
          is_expected.to contain_concat__fragment("zypprepo-versionlock-#{title}").with_content(
            "\ntype: package\n" \
            "match_type: glob\n" \
            "case_sensitive: on\n" \
            "solvable_name: #{title}\n"
          )
        end
      end

      context 'with a release containing dots' do
        let(:title) { 'java-1.7.0-openjdk-1.7.0.121-2.6.8.0.3.x86_64' }

        it_behaves_like 'a well-defined versionlock'
        it 'contains a well-formed Concat::Fragment' do
          is_expected.to contain_concat__fragment("zypprepo-versionlock-#{title}").with_content(
            "\ntype: package\n" \
            "match_type: glob\n" \
            "case_sensitive: on\n" \
            "solvable_name: #{title}\n"
          )
        end
      end

      context 'with an invalid title' do
        let(:title) { 'bash-4.4.1' }

        it { is_expected.to raise_error(Puppet::PreformattedError, %r(%\{NAME\}-%\{VERSION\}-%\{RELEASE\}\.%\{ARCH\})) }
      end

      context 'with an invalid wildcard pattern' do
        let(:title) { 'bash-4.4.9*' }

        it { is_expected.to raise_error(Puppet::PreformattedError, %r(%\{NAME\}-%\{VERSION\}-%\{RELEASE\}\.%\{ARCH\})) }
      end
    end
  end
end
