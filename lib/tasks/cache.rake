namespace :cache do
  desc "Clears all Rails caches"
  task :blitz => :environment do
    Rake::Task["tmp:cache:clear"].invoke
    puts "Rails cache cleared!"
  end
end
