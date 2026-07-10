class EpicEvent < ApplicationRecord
  EVENT_TYPES = %w[added removed].freeze

  belongs_to :epic, optional: true

  validates :event_type, inclusion: { in: EVENT_TYPES }

  scope :recent, -> { order(occurred_at: :desc) }
end
