# RawgentoDB

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


### Configuration

Edit rawgento_db-config.yml to your needs.

    host: 127.0.0.1
    port: 3306
    database: mydb
    username: myuser
    password: mysecret
    attributes:
      shelve_nr: 828
      supplier_name: 921
      packsize: 9291
      name: 283

The first 5 keys define access to the mysql (magento) database.
The later keys define the attribute-id of some more or less custom attributes.

## Usage

`RawgentoDB` defines the following methods:

  - `RawgetoDB.settings`: Reads the aforementioned config file and returns its values (a hash). The settings are needed for all the other operations.
  - `RawgentoDB::Query.products`: Returns an array of Struct(:product_id, :name)s containing most basic Product information
  - `RawgentoDB::Query.stock`: Returns am array of Struct(:product_id, :qty)s containing current stock per product.
  - `RawgentoDB::Query.sales(product_id, settings)`: Returns array of [period, qty_ordered] information for one product.
  - `RawgentoDB::Query.attribute_varchar(attribute_id, settings)`: Returns array of [product_id, attribute_value] varchar-attribute-value information for all products.
  - `RawgentoDB::Query.attribute_option(attribute_id, settings)`: Returns array of [product_id, attribute_value] attribute-value of an option for all products.


Furthermore, some command line applications are provided to get a view on the Shop through the eyes of the `rawgento_db` gem:

  - `rawgento_show_products`: Shows a table of products.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec rawgento_db` to use the gem in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rawgento_db. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

