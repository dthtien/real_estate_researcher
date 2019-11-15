namespace :correct_data do
  desc 'start correct data'

  task start: :environment do
    CorrectDataJob.perform_later
  end
end
