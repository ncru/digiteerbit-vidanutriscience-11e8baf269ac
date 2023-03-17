namespace :db do
  namespace :seed do
    task :custom_seed => :environment do
      filename = Dir[File.join(Rails.root, 'db', 'seeds', "#{ENV['SEED']}.rb")][0]
      puts "Seeding #{filename}..."
      load(filename) if File.exist?(filename)
    end
  end
end
