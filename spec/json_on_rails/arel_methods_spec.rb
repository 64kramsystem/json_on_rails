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

    # WATCH OUT! The semantic of passing an Array/Hash in Rails is not what one would think it
    # would for a JSON data type. This is independent of this gem.
    #
    context "passing collection objects" do
      it "should not find the instance, when searching an empty hash instance" do
        found_user = User.find_by(extras: {})

        expect(found_user).to be(nil)
      end

      it "should not find the instance, when searching an array instance" do
        user.update_attributes!(extras: [1, 2, 3])

        found_user = User.find_by(extras: [1, 2, 3])

        expect(found_user).to be(nil)
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
