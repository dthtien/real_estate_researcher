env :PATH, ENV['PATH']
env :SLACK_HOOK_URL, ENV['SLACK_HOOK_URL']
set :output, "log/cron_log.log"

every :saturday, at: '05:00pm', role: [:app] do
  rake 'scrapping:start'
end
