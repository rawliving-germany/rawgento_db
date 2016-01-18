# RawgentoDb

Interact with a Magento MySQL database, using assumptions of a specific installation

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rawgento_db'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rawgento_db

## Usage

### Configuration

Edit rawgento_db-config.yml to your needs.

host: 127.0.0.1
port: 3306
database: mydb
username: myuser
password: mysecret

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec rawgento_db` to use the gem in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rawgento_db. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

