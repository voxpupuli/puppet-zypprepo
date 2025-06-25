# @summary Valid rpm name with globs.
# Can be alphanumeric or contain `.` `_` `+` `%` `{` `}` `-` `*`.
# Examples python36-*, *netscape
type Zypprepo::RpmNameGlob = Pattern[/\A([*0-9a-zA-Z\._\+%\{\}-]+)\z/]
