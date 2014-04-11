# Analtester

A silly gem for generating minitest files. If you have RSpec, it can use that,
too.

analtester will look through your ./lib directory and create corresponding tests in test/.
They will all fail, until you write them. Use it to quickly populate an untested
library with tests. Just run `analtester` from the command-line in your project's root.

Requires minitest, unless it doesn't.

## Installation

    $ gem install analtester

## Usage

    $ cd myproject
    $ analtest -h

That's it.

[![Build Status](https://travis-ci.org/bjjb/analtester.svg?branch=master)](https://travis-ci.org/bjjb/analtester)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
