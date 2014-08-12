require 'rails_helper'

feature 'Wizard' do
  let(:product_group_name) { 'iPad' }
  let(:second_product_group_name) { 'MacBook PRO' }
  let(:feature_name) { 'Large display' }
  let(:benefit_description) { 'Better photo editing capabilities' }
  let(:invitee_email) { 'invitee@bettersalesman.dev' }
  let(:invitee_display_name) { 'John Doe' }

  before { allow(ApplicationMailer).to receive(:user_invitation) }

  scenario 'Happy path', js: true do
    visit '/'

    # Start wizard
    fill_in 'wizard[email]', with: 'user@example.com'
    click_button I18n.t('helpers.submit.wizard.create')
    expect(page).to have_content I18n.t('wizard.step_1.header')

    # Add product_group
    find("input[ng-model='productGroup.name']").set(product_group_name)
    find("input[type='submit']").click
    expect(page).to have_content "1 - #{product_group_name}"

    # Add another product_group
    find("input[ng-model='productGroup.name']").set(second_product_group_name)
    find("input[type='submit']").click
    expect(page).to have_content "2 - #{second_product_group_name}"

    # Add feature / benefit
    find('button', text: I18n.t('wizard.step_1.next_step_button')).click
    expect(page).to have_content I18n.t('wizard.step_2.header')
    expect(page).to_not have_selector('.argument-list .feature')
    find("select[ng-model='argument.productGroup']").select('iPad')
    find("input[ng-model='argument.feature']").set(feature_name)
    find("input[ng-model='argument.benefit']").set(benefit_description)
    find("input[type='submit']").click
    expect(page).to have_selector('.argument-list .feature')

    # Add invitee
    find('button', text: I18n.t('wizard.step_2.next_step_button')).click
    expect(page).to have_content I18n.t('wizard.step_3.header')
    expect(page).to_not have_selector('div.tab-pane ul li')
    find("input[ng-model='invitation.email']").set(invitee_email)
    find("input[ng-model='invitation.displayName']").set(invitee_display_name)
    find("input[type='submit']").click
    expect(page).to have_selector('div.tab-pane ul li')

    # Summary page
    find('button', text: I18n.t('wizard.step_3.next_step_button')).click
    expect(page).to have_content I18n.t('wizard.step_4.header')
    expect(page).to have_content product_group_name
    expect(page).to have_content feature_name
    expect(page).to have_content benefit_description
    expect(page).to have_content invitee_email
    expect(page).to have_content invitee_display_name

    # Submitting
    find('button', text: I18n.t('wizard.step_4.submit_button')).click
    expect(page).to have_content I18n.t('wizard.create.notifications.success')
    expect(page).to have_content I18n.t('devise.confirmations.account_activation_title')

    # Choose password
    password = '1' * 8
    find("input[name='user[password]']").set(password)
    find("button[type='submit']").click
    expect(page).to have_content I18n.t('devise.confirmations.confirmed')

    expect(Argument).to exist.with(feature: feature_name, benefit: benefit_description)
    expect(ProductGroup.all).to have(2).records
  end
end
