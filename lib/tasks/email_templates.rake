namespace :email_templates do
  desc 'Creates initial Mandrill templates'
  task setup: :environment do
    successes, failures = 0, 0
    EmailTemplates::Setup.new.perform do |language, template, result|
      status = case result
        when Exception
          failures += 1
          "ERROR: #{result.message}"
        else
          successes += 1
          'OK'
      end
      puts "#{language.upcase}: #{template} - #{status}"
    end

    puts "\nTask finished with #{successes} successful tasks and #{failures} failures."
  end
end
