# Repeater

Flexible Ruby code re-execution

## Installation

Add this line to your application's Gemfile:

    gem 'repeater'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install repeater

## Usage

### The possible +options+ :
   *tries*       count of tries (by default 1)
   *timeout*     timeout (by default 0)
   *sleep*       waiting for some sleep in seconds after each attempt (by default 0)
   *on*          what kind of exceptions it is required to catch (by default generic Exception class)
   *matching*    matching some error text by regular expression (by default any text /.*/)
   *logger*      custom logger, for instance Log4R (by default STDOUT)
   *trace*       should we output handled errors? (by default false)
   *silent*      should we generate exception after finishing? (by default false)

### Examples:

 retryable { raise "Some fake error" }
 rp(tries: 10, silent: true) { raise "Some fake error" }

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
