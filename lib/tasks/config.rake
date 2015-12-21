namespace :config do
  desc 'Generates a configuration file for the current Rails environment'

  task :generate => :environment do
    INSTRUMENT_PROCESSES_KEYS_WITHOUT_BARCODE = ["destroy_labware"]
    api = Sequencescape::Api.new(ProcessTracking::Application.config.api_connection_options)
    CONFIG = {}.tap do |configuration|

      configuration[:searches] = {}.tap do |searches|
        puts "Preparing searches ..."

        api.search.all.each do |search|
          searches[search.name] = search.uuid
        end
        configuration[:instrument_processes_keys_without_barcode] = INSTRUMENT_PROCESSES_KEYS_WITHOUT_BARCODE
      end
    end

    # Write out the current environment configuration file
    File.open(File.join(Rails.root, %w{config settings}, "#{Rails.env}.yml"), 'a+') do |file|
      file.puts(CONFIG.to_yaml)
    end
  end

  task :default => :generate
end
