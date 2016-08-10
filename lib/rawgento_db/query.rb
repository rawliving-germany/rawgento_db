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

    def self.update_stock product_id, stock_addition, settings=RawgentoDB.settings
      results = client(settings).query(
        "UPDATE cataloginventory_stock_item SET qty = qty + %f "\
        "WHERE product_id = %d", [stock_addition, product_id])
    end

    def self.set_available_on_stock product_id, settings=RawgentoDB.settings
      result = client(settings).query(
        "SELECT is_in_stock FROM cataloginventory_stock_item "\
        "WHERE product_id = %d AND is_in_stock = 0 AND qty > 0", product_id)
      if result.length && result[0] == 0
        result = client(settings).query(
          "UPDATE cataloginventory_stock_item SET is_in_stock = 1 "\
          "WHERE product_id = %d", product_id)
        result
      else
        "unclear what happened"
      end
    end

    def self.wrongly_not_in_stock settings=RawgentoDB.settings
      query = "SELECT product_id FROM rlg15.cataloginventory_stock_item WHERE qty > 0 AND is_in_stock = 0;"
      results = client(settings).query query
      results.map{|r| r['product_id']}
    end

    # Newer version might require query via entity_id
    # array('aggregation' => $collection->getResource()->getTable('sales/bestsellers_aggregated_monthly')),
    #       "e.entity_id = aggregation.product_id AND aggregation.store_id={$storeId} AND aggregation.period BETWEEN '{$fromDate}' AND '{$toDate}'",
    #       array('SUM(aggregation.qty_ordered) AS sold_quantity')

    def self.sales_daily_between product_id, from_date, to_date, settings=RawgentoDB.settings
      min_date, max_date = [from_date, to_date].minmax
      query = 'SELECT * '\
              'FROM sales_bestsellers_aggregated_daily '\
              'WHERE product_id = %d AND '\
              'period >= \'%s\' AND period <= \'%s\' '\
              'ORDER BY PERIOD DESC' % [product_id, min_date.strftime, max_date.strftime]
      result = client(settings).query(query)
      result.map do |r|
        [r['period'], "%1.0f" % r['qty_ordered']]
      end
    end

    def self.sales_monthly_between product_id, from_date, to_date, settings=RawgentoDB.settings
      min_date, max_date = [from_date, to_date].minmax
      query = 'SELECT DISTINCT * '\
              'FROM sales_bestsellers_aggregated_monthly '\
              'WHERE product_id = %d AND '\
              'period >= \'%s\' AND period <= \'%s\' '\
              'ORDER BY period DESC' % [product_id, min_date.strftime, max_date.strftime]
      result = client(settings).query(query)
      result.map do |r|
        [r['period'], "%1.0f" % r['qty_ordered']]
      end#.uniq
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

    def self.first_sales product_ids, settings=RawgentoDB.settings
      query = "SELECT MIN(period), product_id "\
              "FROM sales_bestsellers_aggregated_daily "\
              "WHERE product_id in (%s) "\
              "GROUP BY product_id" % [product_ids.join(",")]
      result = client(settings).query(query)
      result.map do |r|
        [r['product_id'], r['MIN(period)']]
      end.to_h
    end

    def self.num_sales_since day, product_ids, settings=RawgentoDB.settings
      query = "SELECT SUM(qty_ordered), product_id "\
              "FROM sales_bestsellers_aggregated_daily "\
              "WHERE product_id in (%s) "\
              "  AND period >= '%s' "\
              "GROUP BY product_id" % [product_ids.join(","), day.strftime]

      result = client(settings).query(query)
      result.map do |r|
        [r['product_id'], ProductQty.new(r['product_id'], r['SUM(qty_ordered)'].to_i)]
      end.to_h
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

    def self.product_names product_ids=nil, settings=RawgentoDB.settings
      where = product_ids.nil? ? "" : " WHERE entity_id IN (#{product_ids.join(', ')})"
      query = "SELECT entity_id, name FROM catalog_product_flat_1 #{where};"
      result = client(settings).query(query)
      result.map do |r|
        [r['entity_id'], r['name']]
      end.to_h
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
