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

```puppet
zypprepo { 'openSUSE_12.1':
  baseurl      => 'http://download.opensuse.org/distribution/12.1/repo/oss/suse/',
  enabled      => 1,
  autorefresh  => 1,
  name         => 'openSUSE_12.1',
  gpgcheck     => 0,
  priority     => 98,
  keeppackages => 1,
  type         => 'rpm-md',
}
```

This Puppet 'type' is a port of the 'yumrepo' type from 2.7 code base
and is licensed under the Apache-2.0.
