# frozen_string_literal: true

class SpecEnvironmentHelper
  DB_CONFIGFILE = File.expand_path("config/database.yml", __dir__)
  SCHEMA_FILE = File.expand_path("db/schema.rb", __dir__)
  TEST_MODELS_PATH = File.expand_path("models", __dir__)

  def setup_spec_environment
    setup_coverage_tool
    boot_mini_app
    require_components
    connection_configuration = load_connection_configuration
    prepare_database(connection_configuration)
    autoload_models
  end

  private

  def setup_coverage_tool
    require "coveralls"

    Coveralls.wear!
  end

  def boot_mini_app
    # Requiring rails (/all) is the minimum for using rspec-rails, which gives transactional UTs.
    require "rails/all"

    # Having a Rails app is not strictly required, however, for cleanness, we still boot a "mini" one;
    # otherwise things like Rails.root (not currently used) won't be set.
    #
    # A cool variation is `JsonOnRails.const_set :Application, Class.new(Rails::Application)`
    JsonOnRails.class_eval <<-KLASS, __FILE__, __LINE__ + 1
      class Application < Rails::Application; end
    KLASS
  end

  def require_components
    require "rspec/rails"
    require "json_on_rails"
    Dir.glob("#{__dir__}/../helpers/*.rb").each { |helper| require helper }
  end

  def load_connection_configuration
    erb_db_configuration = ERB.new(File.read(DB_CONFIGFILE)).result
    YAML.safe_load(erb_db_configuration)
  end

  def prepare_database(configuration)
    database = configuration.delete("database")

    ActiveRecord::Base.establish_connection(configuration)
    ActiveRecord::Base.connection.recreate_database(database)

    configuration["database"] = database

    ActiveRecord::Base.establish_connection(configuration)

    load SCHEMA_FILE
  end

  def autoload_models
    # Since we don't have a rails environment (see #require_dependencies), we add the model
    # paths directly. See http://guides.rubyonrails.org/autoloading_and_reloading_constants.html#autoload-paths
    ActiveSupport::Dependencies.autoload_paths << TEST_MODELS_PATH
  end
end
