class ReportArgumentRankingDecorator < ApplicationDecorator
  def feature
    model.feature
  end

  def benefit
    model.benefit
  end

  def owner_with_timestamp
    [
      model.owner.try(:display_name),
      model.created_at.strftime('%H:%M %d.%m.%Y')
    ].compact.join(', ')
  end

  def formatted_rating
    h.number_with_precision(model.cached_rating, precision: 1)
  end
end
