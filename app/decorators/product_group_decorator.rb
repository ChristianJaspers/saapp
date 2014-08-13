class ProductGroupDecorator < ApplicationDecorator
  def publishing_link
    if object.archived_at
      link_to '',
              h.manager_product_group_path(object, product_group: {archive: false}),
              title: I18n.t('manager.product_groups.index.table.actions.unarchive_link'),
              class: 'btn-icon icon-publish',
              method: :patch
    else
      link_to '',
              h.manager_product_group_path(object, product_group: {archive: true}),
              title: I18n.t('manager.product_groups.index.table.actions.archive_link'),
              class: 'btn-icon icon-unpublish',
              method: :patch
    end
  end

  def removal_link
    if object.removable_by?(current_user)
      link_to '',
              h.manager_product_group_path(object.id),
              title: I18n.t('manager.product_groups.index.table.actions.destroy_link'),
              class: 'btn-icon icon-trash',
              method: :delete,
              data: {confirm: I18n.t('manager.product_groups.index.table.actions.destroy_confirmation')}
    end
  end

  def edit_link
    link_to '',
            h.edit_manager_product_group_path(object.id),
            title: I18n.t('manager.product_groups.index.table.actions.edit_link'),
            class: 'btn-icon icon-edit'
  end
end
