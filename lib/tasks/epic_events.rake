namespace :epic_events do
  desc "Backfill EpicEvent timestamps from Jira's changelog (fixes rows stamped at sync time before this existed)"
  task backfill: :environment do
    count = JiraSync.new.backfill_event_times!
    puts "Updated #{count} epic event timestamp(s)."
  end

  desc "Discover epics already closed (SUCCESS/FAILURE/REJECTED/etc) before this app ever tracked them, and backfill their add+remove history"
  task :discover_closed, [ :jql ] => :environment do |_, args|
    jql = args[:jql].presence ||
          'issuetype = Epic AND project = PG AND labels = "Priority" AND status IN (SUCCESS, FAILURE, REJECTED, "GONE BAD")'
    count = JiraSync.new.discover_closed_epics!(jql)
    puts "Backfilled #{count} previously-untracked closed epic(s) using: #{jql}"
  end
end
