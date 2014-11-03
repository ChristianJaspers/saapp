class Api::ArgumentRatingWithBadgeSerializer < Api::ArgumentRatingSerializer
  attributes :device_meta_data

  def device_meta_data
    {
      badge: current_user.unrated_arguments_badge_number
    }
  end
end
