class TransferOwnershipToManager < BusinessProcess::Base
  extend BusinessProcess::Transactional
  transaction_for User

  needs :user

  def call
    find_manager and
      validate_users and
      transfer_data
  end

  private

  def find_manager
    @manager = company.users.managers.order(:id).limit(1).first
  end

  def validate_users
    user.id != manager.id
  end

  def transfer_data
    user.product_groups.update_all(owner_id: manager.id)
    user.arguments.update_all(owner_id: manager.id)
  end

  attr_reader :manager

  delegate :company, to: :user
end
