# frozen_string_literal: true

# Column addition is backed by the same functionality as table creation, but we keep it here for
# documentation purposes.
#
describe "Migrations" do
  before :all do
    RSpec.configure do |config|
      config.use_transactional_fixtures = false
    end
  end

  before :each do
    ActiveRecord::Schema.define do
      drop_table "migration_models" if connection.table_exists?("migration_models")
    end
  end

  after :all do
    RSpec.configure do |config|
      config.use_transactional_fixtures = true
    end
  end

  context "on table creation" do
    it "should support the :json data type" do
      ActiveRecord::Schema.define do
        create_table "migration_models" do |t|
          t.string "login", null: false, limit: 24
          t.column "extras", :json
        end
      end

      MigrationModel.reset_column_information

      expect(MigrationModel.columns_hash["extras"].sql_type).to eql("json")
    end
  end

  context "on table change" do
    it "should support the :json data type" do
      ActiveRecord::Schema.define do
        create_table "migration_models" do |t|
          t.string "login", null: false, limit: 24
        end

        add_column :migration_models, :extras, :json
      end

      MigrationModel.reset_column_information

      expect(MigrationModel.columns_hash["extras"].sql_type).to eql("json")
    end
  end
end
