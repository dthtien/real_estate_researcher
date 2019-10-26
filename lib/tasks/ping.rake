namespace :ping do
  desc 'start scrappings'
  task :puts_log do
    Rails.logger = Logger.new(STDOUT)
  end

  task start: :environment do
    slack_notifier = Slack::Notifier.new ENV['SLACK_HOOK_URL'] do
      defaults(channel: '#real_estate_bugs', username: 'notifier')
    end

    slack_notifier.ping('Starting');
  end
end
