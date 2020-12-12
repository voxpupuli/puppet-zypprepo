# Description of zypper repositories

Puppet::Type.newtype(:zypprepo) do
  @doc = "The client-side description of a zypper repository. Repository
    configurations are found by parsing `/etc/zypp/zypper.conf` and
    the files indicated by the `reposdir` option in that file
    (see `zypper(8)` for details).

    Most parameters are identical to the ones documented
    in the `zypper(8)` man page.

    Continuation lines that zypper supports (for the `baseurl`, for example)
    are not supported. This type does not attempt to read or verify the
    exinstence of files listed in the `include` attribute."

  ensurable
  # Doc string for properties that can be made 'absent'
  ABSENT_DOC = 'Set this to `absent` to remove it from the file completely.'.freeze

  newparam(:name) do
    desc "The name of the repository.  This corresponds to the
      `repositoryid` parameter in `zypper(8)`."
    isnamevar
  end

  newproperty(:descr) do
    desc "A human-readable description of the repository.
      This corresponds to the name parameter in `zypper(8)`.
      #{ABSENT_DOC}"
    newvalue(:absent) { self.should = :absent }
    newvalue(%r{.*}) {}
  end

  newproperty(:mirrorlist) do
    desc "The URL that holds the list of mirrors for this repository.
      #{ABSENT_DOC}"
    newvalue(:absent) { self.should = :absent }
    newvalue(%r{.*}) {}
  end

  newproperty(:baseurl) do
    desc "The URL for this repository. #{ABSENT_DOC}"
    newvalue(:absent) { self.should = :absent }
    # Should really check that it's a valid URL
    newvalue(%r{.*}) {}
  end

  newproperty(:path) do
    desc "The path relative to the baseurl. #{ABSENT_DOC}"
    newvalue(:absent) { self.should = :absent }
    newvalue(%r{.*}) {}
  end

  newproperty(:enabled) do
    desc "Whether this repository is enabled, as represented by a
      `0` or `1`. #{ABSENT_DOC}"
    newvalue(:absent) { self.should = :absent }
    newvalue(%r{(0|1)}) {}
  end

  newproperty(:gpgcheck) do
    desc "Whether to check the GPG signature on packages installed
      from this repository, as represented by a `0` or `1`.
      #{ABSENT_DOC}"
    newvalue(:absent) { self.should = :absent }
    newvalue(%r{(0|1)}) {}
  end

  newproperty(:gpgkey) do
    desc "The URL for the GPG key with which packages from this
      repository are signed. #{ABSENT_DOC}"
    newvalue(:absent) { self.should = :absent }
    # Should really check that it's a valid URL
    newvalue(%r{.*}) {}
  end

  newproperty(:priority) do
    desc "Priority of this repository from 1-99. #{ABSENT_DOC}"
    newvalue(:absent) { self.should = :absent }
    newvalue(%r{[1-9][0-9]?}) {}
  end

  newproperty(:autorefresh) do
    desc "Enable autorefresh of the repository, as represented by a
      `0` or `1`. #{ABSENT_DOC}"
    newvalue(:absent) { self.should = :absent }
    newvalue(%r{(0|1)}) {}
  end

  newproperty(:keeppackages) do
    desc "Enable RPM files caching, as represented by a
      `0` or `1`. #{ABSENT_DOC}"
    newvalue(:absent) { self.should = :absent }
    newvalue(%r{(0|1)}) {}
  end

  newproperty(:type) do
    desc "The type of software repository. Values can match
       `yast2` or `rpm-md` or `plaindir` or `yum` or `NONE`. #{ABSENT_DOC}"
    newvalue(:absent) { self.should = :absent }
    newvalue(%r{yast2|rpm-md|plaindir|yum|NONE}) {}
  end
end
