# @summary Locks package from updates.
#
# @example Sample usage on SLES 12
#   zypprepo::versionlock { 'bash-4.1.2-9.sles12.*':
#     ensure => present,
#   }
#
# @example Sample usage on SLES 15
#   zypprepo::versionlock { 'bash':
#     ensure => present,
#     version => '4.1.2',
#     release => '9.sles15',
#     epoch   => 0,
#     arch    => 'noarch',
#   }
#
#
# @example Sample usage on SLES 12 with new style version, release, epoch, name parameters.
#   zypprepo::versionlock { 'bash':
#     ensure => present,
#     version => '4.1.2',
#     release => '9.sles12',
#     epoch   => 0,
#     arch    => 'noarch',
#   }
#
# @example Simple usage to set package to any version on hold
#   zypprepo::versionlock { 'bash':
#     version => '*',
#   }
#
#
# @param ensure
#   Specifies if versionlock should be `present` or `absent`.
#
# @param version
#   Version of the package if SLES 12 mechanism is used.
#   If version is set then the name var is assumed to a package name and not the full versionlock string.
#
# @param release
#   Release of the package if SLES 12 mechanism is used.
#
# @param arch
#   Arch of the package if SLES 12 mechanism is used.
#
# @param epoch
#   Epoch of the package if SLES 12 mechanism is used.
#
# @note The resource title must use the format
#   By default on SLES 11 the following format is used.
#   "%{NAME}-%{VERSION}-%{RELEASE}.%{ARCH}".  This can be retrieved via
#   the command `rpm -q --qf '%{NAME}-%{VERSION}-%{RELEASE}.%{ARCH}'. Wildcards
#   may be used within token slots, but must not cover seperators, e.g.,
#   'b*sh-4.1.2-9.*' covers Bash version 4.1.2, revision 9 on all
#   architectures.
#   By default on SLES 12 and newer the resource title should be just set to the
#   package name.
#   If a version is set on SLES 11 then it behaves like SLES 12.
#   By default SLES 11 there is no support to set epoch.
#
# @see https://www.unix.com/man-page/suse/5/locks/
define zypprepo::versionlock (
  Enum['present', 'absent']                    $ensure  = 'present',
  Optional[Zypprepo::RpmVersion]               $version = undef,
  Optional[Zypprepo::RpmRelease]               $release = undef,
  Optional[Integer[0]]                         $epoch   = undef,
  Variant[Zypprepo::RpmArch, Enum['*'], Undef] $arch    = undef,
) {
  require zypprepo::plugin::versionlock

  if $version =~ Undef {
    assert_type(Zypprepo::VersionlockString, $name) |$_expected, $actual | {
      # lint:ignore:140chars
      fail("Package name must be formatted as [%{EPOCH}:]%{NAME}-%{VERSION}-%{RELEASE}.%{ARCH}, not \'${actual}\'. See Zypprepo::Versionlock documentation for details.")
      # lint:endignore
    }

    # split the name string into the needed parts
    $_matches = $name.match(/^(?:(\d+):)?(.*)-([^-]+)-([^-]+)\.([^.]+)$/)
    $_epoch = $_matches[1] ? {
      Undef   => '',
      default => "${_matches[1]}:",
    }
    $_solvable_name = $_matches[2]
    $_version = $_matches[3]
    if $_matches[5] =~ Zypprepo::RpmArch or $_matches[5] == '*' {
      $_release = $_matches[4] ? {
        '*'     => '',
        default => "-${_matches[4]}",
      }
      $_solvable_arch = $_matches[5] ? {
        '*'     => undef,
        default => $_matches[5],
      }
    } else {
      $_release = "-${_matches[4]}.${_matches[5]}"
      $_solvable_arch = undef
    }
    $_versionlock = ($_epoch.empty and $_version == '*' and $_release.empty) ? {
      true    => undef,
      default => "${_epoch}${_version}${_release}",
    }
  } else {
    assert_type(Zypprepo::RpmName, $name) |$_expected, $actual | {
      fail("Package name must be formatted as Zypprepo::RpmName, not \'${actual}\'. See Zypprepo::Rpmname documentation for details.")
    }

    assert_type(Zypprepo::RpmVersion, $version) |$_expected, $actual | {
      fail("Version must be formatted as Zypprepo::RpmVersion, not \'${actual}\'. See Zypprepo::RpmVersion documentation for details.")
    }

    $_epoch = $epoch ? {
      Undef   => '',
      default => "${epoch}:",
    }
    $_release = $release ? {
      Undef   => '',
      '*'     => '',
      default => "-${release}",
    }
    $_solvable_name = $name
    $_versionlock = ($_epoch.empty and $version == '*' and $_release.empty) ? {
      true    => undef,
      default => "${_epoch}${version}${_release}",
    }
    $_solvable_arch = $arch
  }

  unless $ensure == 'absent' {
    concat::fragment { "zypprepo-versionlock-${name}":
      content => epp("${module_name}/package_versionlock.epp", {
          'solvable_name' => $_solvable_name,
          'solvable_arch' => $_solvable_arch,
          'version'       => $_versionlock,
      }),
      target  => $zypprepo::plugin::versionlock::path,
    }
  }
}
