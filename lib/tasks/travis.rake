namespace :travis do
  desc 'Encrypt application yml ENVs to travis config (travis globals env must be cleared manually)'
  task encrypt_test_env: :environment do
    app_yml = YAML.load(File.read(Rails.root.join('config', 'application.yml')))
    travis_env = app_yml.reject{|k,v| k != 'test' and v.is_a?(Hash) }
    travis_env.merge!(travis_env.delete('test') || {})
    output = travis_env.map {|k, v| "#{k}=#{v}" }
    output.each do |out|
      puts "Adding env: #{out}"
      system "echo \"#{out}\" | travis encrypt -i --split --add"
    end
  end
end
