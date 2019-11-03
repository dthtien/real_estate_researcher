env :PATH, ENV['PATH']
env :SLACK_HOOK_URL, ENV['SLACK_HOOK_URL']
set :output, "log/cron_log.log"

every :day, at: '11:30pm', role: [:app] do
  rake 'scrapping:start'
end

every :day, at: '12:01am', role: [:app] do
  rake 'logging_prices:start'
end
