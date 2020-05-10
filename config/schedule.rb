env :PATH, ENV['PATH']
env :SLACK_HOOK_URL, ENV['SLACK_HOOK_URL']
set :output, 'log/cron_log.log'

every :day, at: '02:00pm', role: [:app] do
  command "cd #{Rails.root} && rm log/production.log"
end
