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
        confirmation_path: confirmation_path_for_wizard(setup_new_account.manager_raw_confirmation_token)
      }, status: :created
    else
      render json: {
        success: false,
        error: I18n.t("wizard.create.errors.#{ setup_new_account.error }")
      }, status: 200
    end
  end

  private

  def confirmation_path_for_wizard(confirmation_token)
    localized_path(I18n.locale, "/confirmation?confirmation_token=#{confirmation_token}")
  end
end
