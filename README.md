# AutoTune &nbsp; [![Gem Version](https://badge.fury.io/rb/autotune.svg)](https://badge.fury.io/rb/autotune) [![Build Status](https://travis-ci.org/dominicap/auto-tune.svg?branch=master)](https://travis-ci.org/dominicap/auto-tune) [![Code Climate](https://codeclimate.com/github/dominicap/auto-tune/badges/gpa.svg)](https://codeclimate.com/github/dominicap/auto-tune) [![Test Coverage](https://codeclimate.com/github/dominicap/auto-tune/badges/coverage.svg)](https://codeclimate.com/github/dominicap/auto-tune/coverage) [![security](https://hakiri.io/github/dominicap/auto-tune/master.svg)](https://hakiri.io/github/dominicap/auto-tune/master) [![Gitter](https://badges.gitter.im/gitterHQ/gitter.svg)](https://gitter.im/auto-tune)

AutoTune is a fairly simple program that automatically tags music based on information from the iTunes Affiliates API so that you can enjoy the benefits of a well-organized and more importantly, a well tagged music library. AutoTune can tag a variety of music regardless where it was purchased from (Google Play Store, Ripped CDs etc.). AutoTune adds essential music information (Artwork, Artist Name, Album Name etc.), as well as obscure info such as Track ID, Artist ID, and Genre ID, directly from iTunes thus providing a plethora of benefits such as artist profile pictures in iTunes and [Apple Music lyrics](https://support.apple.com/en-us/HT204459), if a subscription is present.

## Prerequisites

Installing AutoTune should be straight-forward if all prerequisites are met. Please make sure your system has the following:

* GNU/Linux, Unix, or macOS

* [TagLib](http://taglib.org) - The metadata tagging software that tags the music.

    - On macOS if [brew](https://brew.sh) is installed, execute:

        `brew install taglib`

    - On debian/ubuntu execute:

        `apt-get install libtag1-dev`

* [Ruby](https://www.ruby-lang.org/en/downloads/) - The language behind the software.

    - On macOS if [brew](https://brew.sh) is installed, execute:

        `brew install ruby`

    - On Linux, it is recommended that you manually compile and install Ruby to ensure the latest version is installed.

* [RubyGems](https://rubygems.org/pages/download) - Package manager needed to install the package.
* [Bundler](http://bundler.io) - Ruby gem needed to install the package dependencies.

    - `gem update && gem install bundler`

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'autotune'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install autotune

## Usage

Usage after installation is fairly simple. That being said, there are a few notable requirements for the music being tagged. Make sure the music being tagged is in the M4A format. If not already in that format, consider using iTunes to convert the music to the iTunes Plus Format. If on Linux, use the highly acclaimed [FFmpeg](https://ffmpeg.org) to convert your music to M4A. Further, the music being tagged do not need to be purchased from the iTunes Store but it needs to be available in the store. A quick google search should ensure whether it is available or not.

With that out of the way usage is as follows:

    $ autotune --album 'album name' --artist 'artist name' --directory 'album directory' [options]

With the options being:

* --deluxe - Enable this option if the album being tagged happens to be the deluxe or exclusive version.

* --clean - Enable this option if the album being tagged happens to be the clean version.

* --single - Enable this option if the album being tagged happens to be a single.

For more information run `autotune` or `autotune --help` to view in detail options and shortcuts provided.

Please note the package is in its early stages and might have issues with some albums. Please consider making a copy of your music before using the package.

If your are planning to use this gem as a package for a different project, documentation is coming soon so hang tight!

## Development

Please feel free to fork this project and add your own contributions and features to it!

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

All input and feedback is welcome. Consider dropping in suggestions and ideas in the [Gitter](https://gitter.im/auto-tune) chat room so we can discuss ideas.

Bug reports and pull requests are welcome on GitHub at https://github.com/dominicap/auto-tune.

## Acknowledgements

Special thanks to the [taglib-ruby](https://github.com/robinst/taglib-ruby) gem which without, this project would cease to exist.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
