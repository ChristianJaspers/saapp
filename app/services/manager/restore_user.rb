class Manager::RestoreUser
  attr_reader :email, :restorer, :restoree

  def initialize(email, restorer)
    @email = email
    @restorer = restorer
  end

  def call
    find_user_to_restore_by_email and
      restore_user
  end

  def find_user_to_restore_by_email
    @restoree ||= User.unscoped.where('remove_at IS NOT NULL AND team_id = ?', restorer.team_id).find_by_email(email)
  end

  private

  attr_reader :restoree

  def restore_user
    restoree.remove_at = nil
    restoree.save
  end
end
