class ProductGroupDecorator < ApplicationDecorator
  def publishing_link
    if object.archived_at
      icon_link_to 'unpublish', h.manager_product_group_path(object, product_group: {archive: false}, locale: I18n.locale),
                   title: I18n.t('manager.product_groups.index.table.actions.unarchive_link'),
                   method: :patch
    else
      icon_link_to 'publish', h.manager_product_group_path(object, product_group: {archive: true}, locale: I18n.locale),
                   title: I18n.t('manager.product_groups.index.table.actions.archive_link'),
                   method: :patch
    end
  end

  def removal_link
    if object.removable_by?(current_user)
      icon_link_to 'trash btn-dark', h.manager_product_group_path(object.id, locale: I18n.locale),
                   title: I18n.t('manager.product_groups.index.table.actions.destroy_link'),
                   method: :delete,
                   data: {confirm: I18n.t('manager.product_groups.index.table.actions.destroy_confirmation')}
    end
  end

  def edit_link
    icon_link_to 'edit', h.edit_manager_product_group_path(object.id, locale: I18n.locale),
                 title: I18n.t('manager.product_groups.index.table.actions.edit_link')
  end

  def icon_link_to(icon_name, path, options)
    options[:class] = "btn-icon icon-#{icon_name}"
    link_to '', path, options
  end
end
