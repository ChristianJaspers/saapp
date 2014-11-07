class ReportArgumentRankingDecorator < ApplicationDecorator
  def product_group_id
    model.product_group_id
  end

  def product_group_name
    model.product_group.name
  end

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

  def link_to_destroy
    h.link_to '', h.manager_argument_path(model),
      class: 'btn-icon icon-trash',
      method: :delete,
      data: {
        confirm: I18n.t('manager.product_groups.index.table.actions.destroy_confirmation')
      }
  end

  def formatted_rating
    h.number_with_precision(model.cached_rating, precision: 1)
  end
end
