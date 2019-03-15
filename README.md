# Mail::Sanitizer

A sanitizer for email's body.
It removes quotation and signature contents from the body.
The following is an example.

Before sanitizing:
```
To: Alice

This is Bob.
Thanks.

Alice wrote:
> To: Bob
>
> This is Alice.
> Hello

---------------
Bob Corporation
Tel: xxx-xxxx-xxxx
Email: bob@example.com
---------------
```

After sanitizing:
```
To: Alice

This is Bob.
Thanks.
```

## Dependencies

- ruby 2.3+

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mail-sanitizer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mail-sanitizer

## Usage

Use as follows:

```ruby
# initialize a sanitizer with email's body
sanitizer = Mail::Sanitizer::Sanitizer.new(body)

# sanitize email's body
sanitized_body = sanitizer.sanitize

# get quotation contents after sanitizing
quot = sanitizer.quot

# get signature contents after sanitizing
sign = sanitizer.sign
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/MasatoMiyoshi/mail-sanitizer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Mail::Sanitizer project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/MasatoMiyoshi/mail-sanitizer/blob/master/CODE_OF_CONDUCT.md).
