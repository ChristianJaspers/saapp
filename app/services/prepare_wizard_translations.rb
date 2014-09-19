class PrepareWizardTranslations
  WIZARD_KEYS = %w(
    common.add
    common.name
    common.none
    common.email
    common.feature
    common.benefit
    common.argument.many
    common.invitation.many
    common.product_group.many

    wizard.step_1.header
    wizard.step_1.at_product_groups_limit_notification
    wizard.step_1.next_step_button

    wizard.step_2.header
    wizard.step_2.next_step_button

    wizard.step_3.header
    wizard.step_3.add_message
    wizard.step_3.next_step_button

    wizard.step_4.header
    wizard.step_4.categories_and_arguments_header
    wizard.step_4.benefit
    wizard.step_4.invitations_header
    wizard.step_4.invitation_message_header
    wizard.step_4.submit_button

    wizard.steps.arguments
    wizard.steps.invitations
    wizard.steps.product_groups
    wizard.steps.summary
  )

  def self.call(gon)
    gon.translations = WIZARD_KEYS.each_with_object({}) do |key, agg|
      agg[key] = I18n.t(key)
    end
    gon.locale = I18n.locale.to_s
  end
end
