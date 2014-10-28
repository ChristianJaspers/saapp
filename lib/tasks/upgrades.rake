namespace :upgrades do
  desc 'Add team_id to product groups (implemented at 2014-10-28)'
  task add_team_to_product_group: :environment do
    puts 'Start..'
    ProductGroup.unscoped.where(team_id: nil).includes(:owner).each do |product_group|
      print "ProductGroup##{product_group.id}.."
      owner = product_group.owner ? product_group.owner : User.unscoped.find(product_group.owner_id)
      product_group.update_column(:team_id, owner.team_id)
      puts 'OK'
    end
    puts 'Done'
  end
end
