require "test_helper"

class EpicEventTest < ActiveSupport::TestCase
  test "accepts known event types" do
    EpicEvent::EVENT_TYPES.each do |type|
      event = EpicEvent.new(jira_key: "PG-1", name: "Epic A", event_type: type, occurred_at: Time.current)
      assert event.valid?, "expected #{type} to be valid"
    end
  end

  test "rejects unknown event types" do
    event = EpicEvent.new(jira_key: "PG-1", name: "Epic A", event_type: "renamed", occurred_at: Time.current)
    assert_not event.valid?
    assert event.errors[:event_type].any?
  end
end
