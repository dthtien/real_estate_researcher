env :PATH, ENV['PATH']
env :SLACK_HOOK_URL, ENV['SLACK_HOOK_URL']
set :output, "log/cron_log.log"

every :sunday, at: '10:00am', role: [:app] do
  rake 'scrapping:start'
end
