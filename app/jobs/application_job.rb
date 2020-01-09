class ApplicationJob < ActiveJob::Base
  rescue_from Exception do |e|
    slack_notifier.ping(e)
  end

  private

  def slack_notifier
    @slack_notifier ||= Slack::Notifier.new ENV['SLACK_HOOK_URL'] do
      defaults(channel: '#errors', username: 'notifier')
    end
  end
end
