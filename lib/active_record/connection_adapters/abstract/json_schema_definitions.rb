# frozen_string_literal: true

require "active_record/connection_adapters/abstract/schema_definitions"

module ActiveRecord
  # Unfortunately, the type shorthands are hardcoded, and the code itself is not encapsulated
  # in a method, so there's not much design freedom.
  # See the file `schema_definitions.rb`.
  #
  module ConnectionAdapters
    class TableDefinition
      def json(*args)
        options = args.extract_options!
        column_names = args
        column_names.each { |name| column(name, :json, options) }
      end
    end

    class Table
      def json(*args)
        options = args.extract_options!
        args.each do |column_name|
          @base.add_column(name, column_name, :json, options)
        end
      end
    end
  end
end
