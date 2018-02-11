# frozen_string_literal: true

class User < ActiveRecord::Base
  attribute :extras, ActiveRecord::Type::Json.new
end
