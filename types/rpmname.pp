# @summary Valid rpm name.
# Can be alphanumeric or contain `.` `_` `+` `%` `{` `}` `-`.
# Output of `rpm -q --queryformat '%{name}\n package`
# Examples python36-foobar, netscape
type Zypprepo::RpmName = Pattern[/\A([0-9a-zA-Z\._\+%\{\}-]+)\z/]
