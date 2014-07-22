class CategoryDecorator < ApplicationDecorator
  delegate :link_to, to: :h

  def publishing_link
    if object.archived_at
      link_to I18n.t('manager.categories.index.table.actions.unarchive_link'),
              h.manager_category_path(object, category: {archive: false}),
              method: :patch
    else
      link_to I18n.t('manager.categories.index.table.actions.archive_link'),
              h.manager_category_path(object, category: {archive: true}),
              method: :patch
    end
  end
end
