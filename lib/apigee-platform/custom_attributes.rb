module ApigeePlatform
  class CustomAttributes

    def initialize(obj)
      @object = obj
      @object.attributes['attributes'] ||= []
      @attributes = @object.attributes['attributes'].inject({}.with_indifferent_access){|res, a| res[a['name']] = a['value']; res}
    end

    def [](key)
      @attributes[key.to_s]
    end

    def []=(key, value)
      delete(key.to_s)
      @object.attributes['attributes'] << {'name' => key.to_s, 'value' => value}
      @attributes[key.to_s] = value
    end

    def delete(key)
      @object.attributes['attributes'].reject!{|a| a['name'] == key.to_s}
      @attributes.delete(key.to_s)
    end

    def method_missing(name)
      @attributes.send(name)
    end

    def inspect
      @attributes.inspect
    end

  end
end