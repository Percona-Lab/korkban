namespace :epic_events do
  desc "Backfill EpicEvent timestamps from Jira's changelog (fixes rows stamped at sync time before this existed)"
  task backfill: :environment do
    count = JiraSync.new.backfill_event_times!
    puts "Updated #{count} epic event timestamp(s)."
  end

  desc "Discover epics already closed (SUCCESS/FAILURE/REJECTED/etc) before this app ever tracked them, and backfill their add+remove history"
  task :discover_closed, [ :jql ] => :environment do |_, args|
    jql = args[:jql].presence || LASER_FOCUS_CONFIG.board.closed_epics_query.presence
    abort "No JQL given. Pass one as an argument or set board.closed_epics_query in the config." if jql.blank?

    count = JiraSync.new.discover_closed_epics!(jql)
    puts "Backfilled #{count} previously-untracked closed epic(s) using: #{jql}"
  end
end
