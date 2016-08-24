# RawgentoDB

Interact with a Magento MySQL database, using assumptions of a specific installation.

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

The first 5 keys define access to the mysql (magento) database.

## Usage

Note that **RawgentoDB does not make any effort to sanitize your input**, which means that crazy and dangerous things can be made with it.

`RawgentoDB` defines the following methods:

  - `RawgetoDB.settings`: Reads the aforementioned config file and returns its values (a hash). The settings are needed for all the other operations.
  - `RawgentoDB::Query.products`: Returns an array of Struct(:product_id, '')s containing the product_id (unfortunately, name is not easily accessible atm).
  - `RawgentoDB::Query.stock`: Returns am array of Struct(:product_id, :qty)s containing current stock per product.
  - `RawgentoDB::Query.understock(settings)`: Returns array of [product_id, qty, min_qty] for products with notify_min_stock smaller than current stock.
  - `RawgentoDB::Query.sales_monthly(product_id, settings)`: Returns array of [period, qty_ordered] information for one product.
  - `RawgentoDB::Query.sales_daily(product_id, settings)`: Returns array of [period, qty_ordered] information for one product.
  - `RawgentoDB::Query.attribute_varchar(attribute_id, settings)`: Returns array of [product_id, attribute_value] varchar-attribute-value information for all products.
  - `RawgentoDB::Query.attribute_option(attribute_id, settings)`: Returns array of [product_id, attribute_value] attribute-value of an option for all products.

All of these can optionally be called with a (second) parameter settings, which is the yaml parsed file.  To initialize the settings, call `RawgentoDB.settings filename`.


Furthermore, some command line applications are provided to get a view on the Shop through the eyes of the `rawgento_db` gem:

  - `rawgento_show_products`: Shows a table of products.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec rawgento_db` to use the gem in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### How to find magento attribute names and values

Some Attribute names/ids are found like this: `SELECT * FROM magentodb.eav_attribute_label;`

Most Attribute names/ids are found like this: `SELECT * FROM magentodb.eav_attribute;`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rawgento_db. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

