namespace :correct_data do
  desc 'start correct data'

  task start: :environment do
    Lands::Corrector.new.call
  end
end
