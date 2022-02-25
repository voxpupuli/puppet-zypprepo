require 'spec_helper'

shared_examples 'a well-defined versionlock' do
  it { is_expected.to compile.with_all_deps }
  it { is_expected.to contain_class('zypprepo::plugin::versionlock') }
end

describe 'zypprepo::versionlock' do
  on_supported_os.each do |os, os_facts|
    case os_facts[:os]['release']['major']
    when '15'
      titles = {
        'well_formatted' => 'bash-4.4-9.10.1.x86_64',
        'trailing_wildcard' => 'bash-4.4-9.10.1.*',
        'complex_wildcard' => 'bash-4.*-*.1',
        'release_containing_dots' => 'java-1.7.0-openjdk-1.7.0.121-2.6.8.0.3.x86_64',
        'invalid' => 'bash-4.4.1',
        'invalid_wildcard' => 'bash-4.4.9*',
      }
    else
      titles = {
        'well_formatted' => 'bash',
        'trailing_wildcard' => 'bash',
        'complex_wildcard' => 'bash',
        'release_containing_dots' => 'bash',
        'invalid' => 22,
        'invalid_wildcard' => 22,
      }
    end
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with a simple, well-formed title' do
        let(:title) { titles['well_formatted'] }

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
        let(:title) { titles['trailing_wildcard'] }

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
        let(:title) { titles['complex_wildcard'] }

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
        let(:title) { titles['release_containing_dots'] }

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
        let(:title) { titles['invalid'] }

        it { is_expected.to raise_error(Puppet::PreformattedError, %r(%\{NAME\}-%\{VERSION\}-%\{RELEASE\}\.%\{ARCH\})) }
      end

      context 'with an invalid wildcard pattern' do
        let(:title) { titles['invalid_wildcard'] }

        it { is_expected.to raise_error(Puppet::PreformattedError, %r(%\{NAME\}-%\{VERSION\}-%\{RELEASE\}\.%\{ARCH\})) }
      end
    end
  end
end
