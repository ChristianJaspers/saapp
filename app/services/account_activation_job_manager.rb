class AccountActivationJobManager
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def create_job
    user.delay(delayed_job_params.merge(run_at: run_at)).send_confirmation_instructions
  end

  def destroy_job
    Delayed::Job.where(delayed_job_params).destroy_all
  end

  private

  def run_at
    Time.now + 10.minutes
  end

  def delayed_job_params
    {
      custom_user_id: user.id,
      custom_task_identifier: task_identifier
    }
  end

  def task_identifier
    'account_activation'
  end
end
