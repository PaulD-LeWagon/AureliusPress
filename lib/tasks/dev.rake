namespace :dev do
  desc "Runs the development server and asset watchers"
  task start: :environment do
    sh "./bin/dev"
  end
end
