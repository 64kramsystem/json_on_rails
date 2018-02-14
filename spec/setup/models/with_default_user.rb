# frozen_string_literal: true

class WithDefaultUser < ActiveRecord::Base
  after_initialize do |instance|
    instance.extras = {}
  end
end
