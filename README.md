# puppet-zypprepo

[![License](https://img.shields.io/github/license/voxpupuli/puppet-zypprepo.svg)](https://github.com/voxpupuli/puppet-zypprepo/blob/master/LICENSE)
[![Build Status](https://travis-ci.org/voxpupuli/puppet-zypprepo.svg?branch=master)](https://travis-ci.org/voxpupuli/puppet-zypprepo)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/zypprepo.svg)](https://forge.puppetlabs.com/puppet/zypprepo)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/zypprepo.svg)](https://forge.puppetlabs.com/puppet/zypprepo)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/zypprepo.svg)](https://forge.puppetlabs.com/puppet/zypprepo)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/zypprepo.svg)](https://forge.puppetlabs.com/puppet/zypprepo)

## Overview

'zypprepo' - The client-side description of a zypper repository.

## Usage

**Version 3.1.0 introduced a rewrite of the zypprepo type and added a full functional provider based on `puppetlabs-yumrepo_core`. The type is now ensurable. To keep previous behavior, it defaults to present, which makes the ensure parameter optional**

```puppet
zypprepo { 'openSUSE_12.1':
  ensure        => present,
  baseurl       => 'http://download.opensuse.org/distribution/12.1/repo/oss/suse/',
  enabled       => 1,
  autorefresh   => 1,
  name          => 'openSUSE_12.1',
  gpgcheck      => 1,
  repo_gpgcheck => 1,
  pkg_gpgcheck  => 1,
  priority      => 98,
  keeppackages  => 1,
  type          => 'rpm-md',
}
```

This Puppet 'type' is a port of the 'yumrepo' type from 2.7 code base
and is licensed under the Apache-2.0.


### Lock a package with the *versionlock* plugin

The `versionlock` type has changed and will now use the `version` and `solvable_arch` keys to lock a package version.

**PLEASE NOTE: Once you define a lock in code, all locks must be defined in code.**

#### Lock via title

Locks explicitly specified packages from updates. Package name must be precisely specified in format *`NAME-VERSION-RELEASE.ARCH`*. Wild card in package name is allowed provided it does not span a field seperator.

```puppet
zypprepo::versionlock { 'bash-4.1.2-9.sles12.*': }
```

Use the following command to retrieve a properly-formated string:

```sh
PACKAGE_NAME='bash'
rpm -q "$PACKAGE_NAME" --qf '%{NAME}-%{VERSION}-%{RELEASE}.%{ARCH}\n'
```

#### Lock with version parameters

```puppet
zypprepo::versionlock { 'bash':
  version => '4.1.2',
  release => '9.sles12',
  arch    => 'x86_64',
  epoch   => 0,
}
```

The wild card chars '\*' and '?' are also supported for all parameters.

This Puppet 'define' is a port of the 'voxpupuli/puppet-yum' in version 5.3.1.
