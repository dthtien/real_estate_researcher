namespace :deploy do
  desc "Invoke rake task"
  task :rake, :name do |_, args|
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env).to_s do
          execute :rake, args[:name]
        end
      end
    end
  end
end
