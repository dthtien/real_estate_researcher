env :PATH, ENV['PATH']
env :SLACK_HOOK_URL, ENV['SLACK_HOOK_URL']
set :output, 'log/cron_log.log'

every :day, at: '01:00am', role: [:app] do
  rake 'scrapping:first'
  rake 'scrapping:second'
  rake 'scrapping:third'
end
