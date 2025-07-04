# frozen_string_literal: true

class ApiKey < ApplicationRecord
  has_secure_token
  belongs_to :bearer, polymorphic: true
end
