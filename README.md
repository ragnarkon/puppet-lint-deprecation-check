# puppet-lint deprecation check

Adds new [puppet-lint](https://github.com/rodjek/puppet-lint) plugins to check for common deprecations.

## Installation

Someday I'll post this on RubyGems.

For now, checkout and build locally, or allow Bundler's functionality to handle it all for you.

## Checks

### hiera_function

Checks for legacy Hiera 3 functions (`hiera`, `hiera_hash`, etc.).

If the `--fix` option is provided, it will attempt to change the `hiera*` function to an appropriate implementation of the `lookup` function.

Refer to [this table](https://puppet.com/docs/puppet/5.2/hiera_migrate_functions.html) for more information.
