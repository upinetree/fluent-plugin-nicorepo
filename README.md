# Fluentd::Plugin::Nicorepo

Input plugin to fetch Nicorepo on Nicovideo.

## Installation

Add this line to your application's Gemfile:

    gem 'fluent-plugin-nicorepo'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-nicorepo

## Usage

This plugin fetches reports of Nicorepo in every `interval` that specified by configuration file as shown below.
You can also specify kind of reports by the optional attribute `kind`.

```
<source>
  type nicorepo
  mail your@email.com   # required: login mail address for nicovideo
  pass password         # required: login password for nicovide
  interval 3h           # optional: interval to fetch reports from nicovideo (defualt: 10 min)
  kind videos           # optional: kind of reports to be filtered [all, videos, lives] (default: all)
  tag nicorepo.idobata
</source>
```

## Contributing

1. Fork it ( https://github.com/upinetree/fluent-plugin-nicorepo/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
