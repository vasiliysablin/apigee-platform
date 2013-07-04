module ApigeePlatform
  module Associations

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods

      def has_many(*args)
        klass_sym = args.first.to_sym
        options = args.extract_options!
        prefix = self.name
        klass_name = prefix + klass_sym.to_s.classify

        instance_eval do
          define_method "#{klass_sym}" do |scope = :all|
            klass = klass_name.constantize
            prefix_params = klass.prefix_options.inject({}) do |res,pair| 
              res[pair.first] = self.send(options[pair.first] || pair.last)
              res 
            end

            if options[:through].present?
              self.send(options[:through]).map do |el|
                klass.instantiate_record(el.attributes, prefix_params)
              end
            else 
              klass.find scope, :params => prefix_params
            end
          end

          define_method "#{klass_sym.to_s.singularize}" do |id = nil|
            if id
              method(klass_sym).call(id)
            else
              method("create_#{klass_sym.to_s.singularize}").call
            end
          end

          define_method "create_#{klass_sym.to_s.singularize}" do |params={}|
            klass = klass_name.constantize
            prefix_params = klass.prefix_options.inject({}){|res,pair| res[pair.last] = self.send(options[pair.first] || pair.last); res }
            klass.new params.merge(prefix_params)
          end

        end

      end

      def belongs_to(*args)
        klass_sym = args.first.to_sym
        options = args.extract_options!
        prefix = "#{self.parent}::"
        klass_name = prefix + klass_sym.to_s.classify
        klass_name = prefix + options[:class_name] if options[:class_name]

        instance_eval do
          define_method "#{klass_sym}" do
            klass = klass_name.constantize
            id_key = options[:key] ? options[:key] : klass.primary_key
            klass.find self.send(id_key)
          end
        end

      end
    end

  end
end
