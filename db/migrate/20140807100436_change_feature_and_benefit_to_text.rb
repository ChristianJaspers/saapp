class ChangeFeatureAndBenefitToText < ActiveRecord::Migration
  def up
    change_column :arguments, :feature, :text
    change_column :arguments, :benefit, :text
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
