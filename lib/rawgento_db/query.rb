require 'mysql2'

module RawgentoDB
  Product    = Struct.new(:product_id, :name)
  ProductQty = Struct.new(:product_id, :qty)

  class Query
    def self.client settings
      Mysql2::Client.new settings
    end

    def self.products settings
      result = client(settings).query('SELECT product_id, name '\
                                      'FROM cataloginventory_stock_item csi'\
                                      '  JOIN catalog_product_flat_1 cpf ON'\
                                      '    csi.product_id=cpf.entity_id')
      result.map do |r|
        Product.new r["product_id"], r["name"]
      end
    end

    def self.stock settings
      result = client(settings).query('SELECT product_id, qty '\
                                      'FROM cataloginventory_stock_item ')
      result.map do |r|
        ProductQty.new r["product_id"], r["qty"].to_i
      end
    end

    def self.sales product_id, settings
      result = client(settings).query('SELECT * '\
                                      'FROM sales_bestsellers_aggregated_monthly '\
                                      ' WHERE product_id = %d ORDER BY period DESC' % product_id)
      result.map do |r|
        [r['period'], "%1.0f" % r['qty_ordered']]
      end
    end
  end
end
