class ProductGroupDecorator < ApplicationDecorator
  def publishing_link
    if object.archived_at
      link_to I18n.t('manager.product_groups.index.table.actions.unarchive_link'),
              h.manager_product_group_path(object, product_group: {archive: false}),
              method: :patch
    else
      link_to I18n.t('manager.product_groups.index.table.actions.archive_link'),
              h.manager_product_group_path(object, product_group: {archive: true}),
              method: :patch
    end
  end

  def removal_link
    if object.removable_by?(current_user)
      link_to I18n.t('manager.product_groups.index.table.actions.destroy_link'),
              h.manager_product_group_path(object.id),
              method: :delete
    end
  end

  def edit_link
    link_to I18n.t('manager.product_groups.index.table.actions.edit_link'), h.edit_manager_product_group_path(object.id)
  end
end
