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

  desc 'Reorder product groups positions to behave as "created_at ASC" (implemented at 2014-10-28)'
  task reorder_product_groups_from_oldest_to_newest: :environment do
    puts 'Start..'
    ProductGroup.unscoped.includes(:team).order(:created_at).group_by do |product_group|
      [
        product_group.team_id,
        product_group.remove_at
      ]
    end.each do |(team_id, remove_at), product_groups|
      puts "Team##{team_id} (archive_at: #{remove_at ? remove_at : 'nil'}):"
      product_groups.each_with_index do |product_group, index|
        print "  ProductGroup##{product_group.id}, set "
        position = index + 1
        print "position = #{position} .."
        product_group.update_column(:position, position)
        puts 'OK'
      end
    end
    puts 'Done'
  end
end
