# frozen_string_literal: true

ActiveRecord::Schema.define(version: 20180214000000) do
  create_table "users" do |t|
    t.json "extras"
  end

  create_table "with_default_users" do |t|
    t.json "extras"
  end
end
