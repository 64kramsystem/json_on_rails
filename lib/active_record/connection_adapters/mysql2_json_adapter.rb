# frozen_string_literal: true

require "active_record/connection_adapters/mysql2_adapter"
require "active_record/type/json"

# ActiveRecord resources:
#
#     lib/active_record/connection_adapters/mysql2_adapter.rb
#     lib/active_record/connection_adapters/abstract_mysql_adapter.rb
#     lib/active_record/schema_dumper.rb
#
# and a few other files.
#
module ActiveRecord
  module ConnectionHandling
    def mysql2_json_connection(config)
      config = config.symbolize_keys

      config[:username] = "root" if config[:username].nil?

      if Mysql2::Client.const_defined? :FOUND_ROWS
        config[:flags] = Mysql2::Client::FOUND_ROWS
      end

      client = Mysql2::Client.new(config)
      options = [config[:host], config[:username], config[:password], config[:database], config[:port], config[:socket], 0]
      ConnectionAdapters::Mysql2JsonAdapter.new(client, logger, options, config)
    rescue Mysql2::Error => error
      if error.message.include?("Unknown database")
        raise ActiveRecord::NoDatabaseError.new(error.message, error)
      else
        raise
      end
    end
  end
end

module ActiveRecord
  module ConnectionAdapters
    class Mysql2JsonAdapter < Mysql2Adapter
      ADAPTER_NAME = "Mysql2Json".freeze

      def native_database_types
        super.merge(json: {name: "json"})
      end

      protected

      def initialize_type_map(m)
        super

        m.register_type %r{json}i, Type::Json.new
      end
    end
  end
end
