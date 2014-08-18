class AddLocaleToUsers < ActiveRecord::Migration
  def up
    add_column :users, :locale, :string, default: 'en', null: false
    User.unscoped.update_all(locale: 'en')
  end

  def down
    remove_column :users, :locale
  end
end
