class EpicHistoryController < ApplicationController
  def show
    @events_by_day = EpicEvent.recent.limit(500).group_by { |e| e.occurred_at.to_date }
  end
end
