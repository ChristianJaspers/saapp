class WizardsController < ApplicationController
  expose(:wizard, strategy: DecentExposure::ActiveRecordWithEagerAttributesStrategy)

  def new
    render 'home/show' unless wizard.valid?
    gon.email = wizard.email
    PrepareWizardTranslations.call(gon)
  end

  def create
    I18n.locale = read_locale
    setup_new_account = SetupNewAccount.call(self)
    if setup_new_account.success?
      flash[:notice] = t('wizard.create.notifications.success')
      render json: {
        success: true,
        confirmation_token: setup_new_account.manager_raw_confirmation_token
      }, status: :created
    else
      render json: {
        success: false,
        error: I18n.t("wizard.create.errors.#{ setup_new_account.error }")
      }, status: 200
    end
  end
end
