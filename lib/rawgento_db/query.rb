require 'mysql2'

module RawgentoDB
  Product    = Struct.new(:product_id, :name)
  ProductQty = Struct.new(:product_id, :qty)

  class Query
    def self.client settings=RawgentoDB.settings
      # Pick up a memoized settings?
      Mysql2::Client.new settings
    end

    def self.products settings=RawgentoDB.settings
      # Unfortunately, name is an own attribute in different table.
      result = client(settings).query('SELECT entity_id '\
                                      'FROM catalog_product_entity')
      result.map do |r|
        Product.new r["entity_id"], r[""]
      end
    end

    def self.stock settings=RawgentoDB.settings
      result = client(settings).query('SELECT product_id, qty '\
                                      'FROM cataloginventory_stock_item ')
      result.map do |r|
        ProductQty.new r["product_id"], r["qty"].to_i
      end
    end

    def self.understocked settings=RawgentoDB.settings
      results = client(settings).query(
        "SELECT product_id, qty, notify_stock_qty "\
        "FROM cataloginventory_stock_item "\
        "WHERE notify_stock_qty > qty;")
      results.map do |row|
        [row['product_id'], row['name'],
         row['notify_stock_qty'], row['qty']]
      end
    end

    def self.sales_monthly product_id, settings=RawgentoDB.settings
      result = client(settings).query('SELECT * '\
                                      'FROM sales_bestsellers_aggregated_monthly '\
                                      ' WHERE product_id = %d ORDER BY period DESC' % product_id)
      result.map do |r|
        [r['period'], "%1.0f" % r['qty_ordered']]
      end
    end

    def self.sales_daily product_id, settings=RawgentoDB.settings
      result = client(settings).query('SELECT * '\
                                      'FROM sales_bestsellers_aggregated_daily '\
                                      ' WHERE product_id = %d ORDER BY period DESC' % product_id)
      result.map do |r|
        [r['period'], "%1.0f" % r['qty_ordered']]
      end
    end

    def self.attribute_varchar attribute_id, settings=RawgentoDB.settings
      result = client(settings).query("
        SELECT entity_id, value
        FROM catalog_product_entity_varchar
        WHERE attribute_id=#{attribute_id};")
      result.map do |r|
        [r['entity_id'], r['value']]
      end
    end

    def self.attribute_option attribute_id, settings=RawgentoDB.settings
      # Join
      result = client(settings).query("
        SELECT optchoice.entity_id, optval.value
        FROM eav_attribute_option_value as optval,
             catalog_product_entity_int as optchoice
        WHERE optchoice.attribute_id=#{attribute_id}
              AND optval.option_id=optchoice.value;")
      result.map do |r|
        [r['entity_id'], r['value']]
      end
    end
  end
end
