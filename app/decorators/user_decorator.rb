class UserDecorator < ApplicationDecorator
  def removal_link
    link_to '',
            h.manager_user_path(object.id),
            title: I18n.t('manager.users.index.table.actions.destroy_link'),
            class: 'btn-icon icon-trash btn-dark',
            method: :delete,
            data: {confirm: I18n.t('manager.users.index.table.actions.destroy_confirmation')}
  end

  def edit_link
    link_to '',
            h.edit_manager_user_path(object.id),
            title: I18n.t('manager.users.index.table.actions.edit_link'),
            class: 'btn-icon icon-edit'
  end
end
