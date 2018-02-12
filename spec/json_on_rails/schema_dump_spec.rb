# frozen_string_literal: true

describe "Schema dump" do
  it "should support the json data type" do
    output = ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, StringIO.new)

    expect(output.string).to match(/t.json "extras"/)
  end
end
