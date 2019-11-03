env :PATH, ENV['PATH']
env :SLACK_HOOK_URL, ENV['SLACK_HOOK_URL']
set :output, 'log/cron_log.log'

# every :day, at: '3:00pm', role: [:app] do
#   rake 'scrapping:start'
# end

every :day, at: '4:31pm', role: [:app] do
  rake 'scrapping:first_district'
end

every :day, at: '4:32pm', role: [:app] do
  rake 'scrapping:second_district'
end

every :day, at: '4:33pm', role: [:app] do
  rake 'scrapping:third_district'
end


every :day, at: '05:00pm', role: [:app] do
  rake 'logging_prices:start'
end
