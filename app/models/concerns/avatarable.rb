module Avatarable
  extend ActiveSupport::Concern

  included do
    validates :avatar,
                      format: { with: URI.regexp },
                      allow_nil: true
  end
end
