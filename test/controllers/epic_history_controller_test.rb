require "test_helper"

class EpicHistoryControllerTest < ActionDispatch::IntegrationTest
  setup do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
      provider: "google_oauth2", uid: "u1",
      info: { email: "alice@example.com", name: "Alice" }
    )
    get "/auth/google_oauth2/callback"
  end

  test "renders recorded epic events" do
    EpicEvent.create!(jira_key: "PG-1", name: "Epic A", event_type: "added", occurred_at: Time.current)
    EpicEvent.create!(jira_key: "PG-2", name: "Epic B", event_type: "removed", occurred_at: Time.current)

    get "/history"

    assert_response :success
    assert_select ".kb-history-row.is-added", text: /Epic A/
    assert_select ".kb-history-row.is-removed", text: /Epic B/
    base = LASER_FOCUS_CONFIG.jira.base_url.chomp("/")
    assert_select ".kb-history-row.is-added a.kb-history-link[href=?]", "#{base}/browse/PG-1", text: /Epic A/
    assert_select ".kb-history-row.is-removed a.kb-history-link[href=?]", "#{base}/browse/PG-2", text: /Epic B/
  end

  test "redirects to login when unauthenticated" do
    reset!
    get "/history"
    assert_redirected_to "/login"
  end
end
