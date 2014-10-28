namespace :upgrades do
  desc 'Add team_id to product groups (implemented at 2014-10-28)'
  task add_team_to_product_group: :environment do
    puts 'Start..'
    ProductGroup.unscoped.where(team_id: nil).includes(:owner).each do |product_group|
      print "ProductGroup##{product_group.id}.."
      owner = product_group.owner ? product_group.owner : User.unscoped.find_by_id(product_group.owner_id)
      # if user still not found try to find any other user connected somehow to product group
      unless owner
        user_ids = []
        owner = product_group.arguments.each do |argument|
          user_ids << argument.owner_id
          argument.ratings.each do |rating|
            user_ids << rating.rater_id
          end
        end
        user_ids.uniq!
        owner = User.unscoped.where(id: user_ids).limit(1).first
      end

      if owner
        product_group.update_column(:team_id, owner.team_id)
        puts 'OK'
      else
        puts 'Fail'
      end
    end
    puts 'Done'
  end
end
