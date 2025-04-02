# ioprio

A simple ruby API for the linux ioprio system.

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

The ioprio syscalls are only supported by linux systems. As such their wrappers (`ioprio_get`/`ioprio_set`) will only be implemented when built and run on a linux system.

All features either directly call or are a recreation of native ioprio system features. Refer to the linux man pages for usage instructions.

In ruby, the following constants and methods are defined on the `Process` module, corresponding to their native macros and syscalls:

```ruby
  Process::IOPRIO_CLASS_NONE
  Process::IOPRIO_CLASS_RT
  Process::IOPRIO_CLASS_BE
  Process::IOPRIO_CLASS_IDLE

  Process::IOPRIO_WHO_PROCESS
  Process::IOPRIO_WHO_PGRP
  Process::IOPRIO_WHO_USER

  Process.ioprio_prio_class(priority)
  Process.ioprio_prio_data(priority)
  Process.ioprio_prio_value(klass, data)

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
