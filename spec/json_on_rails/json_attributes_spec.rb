# frozen_string_literal: true

describe "JSON attributes", :include_json_attributes_spec_helper do
  context "with invalid root data types" do
    invalid_root_data = [1, 1.5, Date.today, Object.new]

    invalid_root_data.each do |value|
      it "should refuse a #{value.class}" do
        expected_error = [ArgumentError, "Invalid data type for JSON serialization: #{value.class} (only Hash/Array/nil supported)"]
        expect { User.create!(extras: value) }.to raise_error(*expected_error)
      end
    end
  end

  context "with valid root data types" do
    valid_root_data = [
      nil,
      [1, 2, 3],
      {"key" => "value"},
    ]

    valid_root_data.each do |source_value|
      it "should save, read and load a #{source_value.class}" do
        extras_on_user_lifecycle(source_value) do |after_instantiation, after_save, after_reload|
          expect(after_instantiation).to eql(source_value)
          expect(after_save).to eql(source_value)
          expect(after_reload).to eql(source_value)
        end
      end
    end
  end

  # String, differently from Hash and Array, is not transformed at ActiveRecord level, and it's not
  # a valid JSON root data type - it represents a serialized JSON object.
  #
  context "with a String passed as root value" do
    it "should save, read and load" do
      extras_on_user_lifecycle("[1, 2, 3]") do |after_instantiation, after_save, after_reload|
        expect(after_instantiation).to eql([1, 2, 3])
        expect(after_save).to eql([1, 2, 3])
        expect(after_reload).to eql([1, 2, 3])
      end
    end
  end

  context "(inside an array)" do
    context "with JSON native node data types" do
      # Hash/Array/nil are tested already, however, in this context, they prove nesting.
      json_native_node_data = [
        1.5,
        1,
        "doom",
        true,
        {"johncarmack" => "the great"},
        ["doom"],
        nil,
      ]

      json_native_node_data.each do |source_value|
        it "should save, read and load a #{source_value.class}" do
          extras_on_user_lifecycle([source_value]) do |after_instantiation, after_save, after_reload|
            expect(after_instantiation).to eql([source_value])
            expect(after_save).to eql([source_value])
            expect(after_reload).to eql([source_value])
          end
        end
      end

      # README!!! Important. MySQL <= 8.0.4 automatically converts decimals with zero fractional
      # part to integers, so this must be taken into account (see https://bugs.mysql.com/bug.php?id=88230).
      #
      if JsonAttributesSpecHelper.mysql_version < Gem::Version.new("8.0.4")
        it "should return an Integer for Floats with zero fractional part" do
          extras_on_user_lifecycle([1.0]) do |after_instantiation, after_save, after_reload|
            expect(after_instantiation).to eql([1.0])
            expect(after_save).to eql([1.0])
            expect(after_reload).to eql([1])
          end
        end
      else
        it "should return a Float for Floats with zero fractional part" do
          extras_on_user_lifecycle([1.0]) do |after_instantiation, after_save, after_reload|
            expect(after_instantiation).to eql([1.0])
            expect(after_save).to eql([1.0])
            expect(after_reload).to eql([1.0])
          end
        end
      end
    end

    # README!!! This is the most important. Note how values are transformed immediately after
    # instantiation.
    #
    context "with non-JSON native node data types" do
      non_json_native_node_data = [
        [{commodore64: :rocks},            {"commodore64" => "rocks"}],
        [Date.new(1981, 4, 10),            "1981-04-10"],
        [Time.utc(2018, 2, 10, 22, 19, 0), "2018-02-10T22:19:00.000Z"],
      ]

      non_json_native_node_data.each do |source_value, expected_value|
        it "should save, read and load a #{source_value.class}" do
          extras_on_user_lifecycle([source_value]) do |after_instantiation, after_save, after_reload|
            expect(after_instantiation).to eql([expected_value])
            expect(after_save).to eql([expected_value])
            expect(after_reload).to eql([expected_value])
          end
        end
      end
    end
  end
end
