# SimpleConf

Simple configuration library for the loading yml files from the config folder.

[![Build Status](https://secure.travis-ci.org/oivoodoo/simple-conf.png?branch=master)](http://travis-ci.org/oivoodoo/simple-conf)

## Installation

Add this line to your application's Gemfile:

    gem 'simple-conf'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple-conf

## Usage

Define in your project class like:

```ruby
  class Configuration
    include SimpleConf
  end
```

Create in the config folder configuration.yml file with content like:

```yaml
  staging:
    domain: "staging.example.com"
    links:
      - test1.example.com
      - test2.example.com
  production:
    domain: "production.example.com"
```

Now you can use your file in the project:

```ruby
  Configuration.staging.domain
  Configuration.staging.links
  Configuration.production.domain
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
