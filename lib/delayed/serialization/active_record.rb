if defined?(ActiveRecord)
  module ActiveRecord
    class Base
      yaml_as 'tag:ruby.yaml.org,2002:ActiveRecord'

      def self.yaml_new(klass, _tag, val)
        attribute_name = if ActiveRecord::VERSION::MAJOR == 4 && ActiveRecord::VERSION::MINOR >=2
          'raw_attributes'
        else
          'attributes'
        end
        klass.unscoped.find(val[attribute_name][klass.primary_key])
      rescue ActiveRecord::RecordNotFound
        raise Delayed::DeserializationError, "ActiveRecord::RecordNotFound, class: #{klass} , primary key: #{val[attribute_name][klass.primary_key]}"
      end

      def to_yaml_properties
        ['@attributes']
      end
    end
  end
end
