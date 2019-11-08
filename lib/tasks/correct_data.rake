namespace :correct_data do
  desc 'start scrappings'

  task start: :environment do
    Lands::Corrector.new.call
  end
end
