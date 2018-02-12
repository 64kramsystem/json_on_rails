# frozen_string_literal: true

# ActiveRecord resources:
#
#     lib/active_record/attributes.rb
#     lib/active_record/type/value.rb
#     lib/active_record/type/mutable.rb
#
module ActiveRecord
  module Type
    class Json < Type::Value
      include Type::Mutable

      def type
        :json
      end

      def type_cast_for_database(value)
        case value
        when Array, Hash
          value.to_json
        when ::String, nil
          value
        else
          raise ArgumentError, "Invalid data type for JSON serialization: #{value.class} (only Hash/Array/nil supported)"
        end
      end

      private

      def cast_value(value)
        if value.is_a?(::String)
          JSON.parse(value)
        else
          raise "Unexpected JSON data type when loading from the database: #{value.class}"
        end
      end
    end
  end
end
