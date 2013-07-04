module ApigeePlatform::Objects
  class Base < ActiveResource::Base
    include ApigeePlatform::Associations

    def initialize(*args)
      super(*args)
      @id = self.attributes[self.class.primary_key]
      self
    end

    def custom_attributes
      @custom_attributes ||= ApigeePlatform::CustomAttributes.new(self)
    end

    def encode(options={}) 
      super options.merge(:root => false)
    end

    def load(*args)
      super(*args)
      self.attributes['attributes'].map!{|r| {'name' => r.name, 'value' => r.value}} if self.attributes['attributes']

      self.class.prefix_options.each do |k,v|
        self.prefix_options[k] = self.attributes[v]
      end
      self.onload if self.respond_to?(:onload)
      self
    end

    def id 
      # need that to get correct element_path when update resource object
      @id ||= self.attributes[self.class.primary_key]
    end

    class << self    
      attr_reader :config

      def configure(config)
        @config = config.symbolize_keys.slice(:user, :password, :organization, :url)
        @config[:url] ||= 'https://api.enterprise.apigee.com'

        self.site = @config[:url] + '/v1/o/' + @config[:organization]
        self.user = @config[:user]
        self.password = @config[:password]

        require 'apigee-platform/objects/api'
        require 'apigee-platform/objects/apiproduct'
        require 'apigee-platform/objects/app'
        require 'apigee-platform/objects/key'
        require 'apigee-platform/objects/company'
        require 'apigee-platform/objects/company_app'
        require 'apigee-platform/objects/company_app_key'
        require 'apigee-platform/objects/developer'
        require 'apigee-platform/objects/developer_app'
        require 'apigee-platform/objects/developer_app_key'

        self
      end

      def set_prefix_options(options)
        @prefix_options = options
      end

      def prefix_options
        @prefix_options || []
      end

      def instantiate_record(record, prefix_options = {})
        return record unless record.is_a?(Hash)
        super(record, prefix_options)
      end

      def collection_path(prefix_options = {}, query_options = nil)
        check_prefix_options(prefix_options)
        prefix_options, query_options = split_options(prefix_options) if query_options.nil?
        "#{prefix(prefix_options)}#{collection_name}#{query_string(query_options)}"
      end

      def element_path(id, prefix_options = {}, query_options = nil)
        check_prefix_options(prefix_options)
        prefix_options, query_options = split_options(prefix_options) if query_options.nil?
        "#{prefix(prefix_options)}#{collection_name}/#{URI.parser.escape id.to_s}#{query_string(query_options)}"
      end
    end

  end

end