# ioprio

Simple wrappers for linux ioprio syscalls.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add ioprio
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install ioprio
```

## Usage

The ioprio syscalls are only supported by linux systems and as such the following API methods will only be implemented
when running on them.

All behavior is delegated directly to the syscalls themselves. Refer to the man pages for usage
instructions.

Wrapper methods and constants for which values are defined on the `Process` module:

```ruby
  Process::IOPRIO_WHO_PROCESS
  Process::IOPRIO_WHO_PGRP
  Process::IOPRIO_WHO_USER

  Process.ioprio_get(which, who)
  Process.ioprio_set(which, who, priority)
```

## Development

* Run `bin/setup` to install dependencies.
* Run `bin/rake spec` to run the tests.
* Run `bin/rake rubocop` to run the linter.
* Run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/benmelz/ioprio.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
