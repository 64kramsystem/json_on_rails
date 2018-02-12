# frozen_string_literal: true

describe "AREL Methods" do
  let!(:user) { User.create!(extras: {}) }

  context "#find_by" do
    # IMPORTANT! The equality operator doesn't work as expected with JSON columns, when expecting
    # a string comparison; for that, the LIKE operator must be used (see below).
    #
    it "should not find the instance, when searching via equality operator" do
      found_user = User.find_by("extras = ?", "{}")

      expect(found_user).to be(nil)
    end

    it "should not find the instance, when searching via LIKE operator" do
      found_user = User.find_by("extras LIKE ?", "{}")

      expect(found_user).to eql(user)
    end

    # WATCH OUT! AREL finders are (appropriately) not overloaded. In order to perform JSON-specific
    # comparisons, use the MySQL operators (see above).
    #
    context "passing collection objects" do
      it "should not find the instance, when searching an empty hash instance" do
        found_user = User.find_by(extras: {})

        expect(found_user).to be(nil)
      end

      it "should raise an error, when searching an array instance" do
        error_message = "Invalid data type for JSON serialization: #{1.class} (only Hash/Array/nil supported)"

        expect { User.find_by(extras: [1, 2, 3]) }.to raise_error(ArgumentError, error_message)
      end
    end
  end

  context "#update_all" do
    it "should update the records" do
      User.all.update_all(extras: [1, "a"])

      expect(user.reload.extras).to eql([1, "a"])
    end
  end
end
