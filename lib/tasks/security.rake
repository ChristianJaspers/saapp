namespace :security do
  desc 'Generates Mixed-Case Alphanumeric token with 40 characters length'
  task gen_token: :environment do
    puts 'Your token:'
    puts KeePass::Password.generate('A' * 40)
  end
end
