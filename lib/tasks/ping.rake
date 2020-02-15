namespace :ping do
  task start: :environment do
    slack_notifier = Slack::Notifier.new ENV['SLACK_HOOK_URL'] do
      defaults(channel: '#errors', username: 'notifier')
    end

    slack_notifier.ping('Deploy success');
  end
end
