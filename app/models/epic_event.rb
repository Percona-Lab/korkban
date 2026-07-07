class EpicEvent < ApplicationRecord
  belongs_to :epic, optional: true

  scope :recent, -> { order(occurred_at: :desc) }
end
