class UserDecorator < ApplicationDecorator
  def removal_link
    link_to I18n.t('manager.users.index.table.actions.destroy_link'),
            h.manager_user_path(object.id),
            method: :delete,
            data: {confirm: I18n.t('manager.users.index.table.actions.destroy_confirmation')}
  end

  def edit_link
    link_to I18n.t('manager.users.index.table.actions.edit_link'), h.edit_manager_user_path(object.id)
  end
end
