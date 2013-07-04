module ApigeePlatform::Objects
  #abstract class, describes behavior of api keys, nested in developer_app and company_app
  class Key < Base
    def self.element_name
      'key'
    end

    def approve
      connection.post element_path
    end

    def add_product(product_name)
      unless apiproducts[product_name]
        connection.post element_path, {
          :apiProducts => apiproducts.keys + [product_name]
        }.to_json
        apiproducts[product_name] = 'pending'
      end
    end

    def approve_product(product_name)
      return false unless apiproducts[product_name]
      connection.post "#{element_path}/apiproducts/#{product_name}?action=approve", '', {'Content-Type' => 'application/octet-stream'}
      apiproducts[product_name] = 'approved'
    end
    
    def revoke_product(product_name)
      return false unless apiproducts[product_name]
      connection.post "#{element_path}/apiproducts/#{product_name}?action=revoke", '', {'Content-Type' => 'application/octet-stream'}
      apiproducts[product_name] = 'revoked'
    end

    def remove_product(product_name)
      return false unless apiproducts[product_name]
      connection.delete "#{element_path}/apiproducts/#{product_name}"
      apiproducts.delete(product_name)
      true
    end

    def apiproducts
      self.attributes['apiProducts']
    end

    def onload
      self.attributes['apiProducts'] = self.attributes['apiProducts'].inject({}){|res, el| res[el.apiproduct] = el.status; res  }
    end

  end
end