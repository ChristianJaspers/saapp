require 'rails_helper'

feature 'Wizard' do
  let(:product_group_name) { 'iPad' }
  let(:second_product_group_name) { 'MacBook PRO' }
  let(:feature_name) { 'Large display' }
  let(:benefit_description) { 'Better photo editing capabilities' }
  let(:invitee_email) { 'invitee@bettersalesman.dev' }
  let(:invitee_display_name) { 'John Doe' }

  before do
    allow(ApplicationMailer).to receive(:user_invitation).and_call_original
    allow(MandrillDeviseMailer).to receive(:confirmation_instructions).and_call_original
    allow_any_instance_of(EmailTemplates::Sender).to receive(:send).and_return([])
  end

  shared_examples 'Happy wizard path' do
    scenario 'Happy path', js: true do
      visit '/'

      # Start wizard
      fill_in 'wizard[email]', with: 'user@example.com'
      click_button I18n.t('helpers.submit.wizard.create', locale: locale)
      expect(page).to have_content I18n.t('wizard.step_1.header', locale: locale)

      # Add product_group
      find("input[ng-model='productGroup.name']").set(product_group_name)
      find("input[type='submit']").click
      expect(page).to have_content "1 - #{product_group_name}"

      # Add another product_group
      find("input[ng-model='productGroup.name']").set(second_product_group_name)
      find("input[type='submit']").click
      expect(page).to have_content "2 - #{second_product_group_name}"

      # Add feature / benefit
      find('button', text: I18n.t('wizard.step_1.next_step_button', locale: locale)).click
      expect(page).to have_content I18n.t('wizard.step_2.header', locale: locale)
      expect(page).to_not have_selector('.argument-list .feature')
      find("select[ng-model='argument.productGroup']").select('iPad')
      find("input[ng-model='argument.feature']").set(feature_name)
      find("input[ng-model='argument.benefit']").set(benefit_description)
      find("input[type='submit']").click
      expect(page).to have_selector('.argument-list .feature')

      # Add invitee
      find('button', text: I18n.t('wizard.step_2.next_step_button', locale: locale)).click
      expect(page).to have_content I18n.t('wizard.step_3.header', locale: locale)
      expect(page).to_not have_selector('div.tab-pane ul li')
      find("input[ng-model='invitation.email']").set(invitee_email)
      find("input[ng-model='invitation.displayName']").set(invitee_display_name)
      find("input[type='submit']").click
      expect(page).to have_selector('div.tab-pane ul li')

      # Summary page
      find('button', text: I18n.t('wizard.step_3.next_step_button', locale: locale)).click
      expect(page).to have_content I18n.t('wizard.step_4.header', locale: locale)
      expect(page).to have_content product_group_name
      expect(page).to have_content feature_name
      expect(page).to have_content benefit_description
      expect(page).to have_content invitee_email
      expect(page).to have_content invitee_display_name

      # Submitting
      find('button', text: I18n.t('wizard.step_4.submit_button', locale: locale)).click
      expect(page).to have_content I18n.t('wizard.create.notifications.success', locale: locale)
      expect(page).to have_content I18n.t('devise.confirmations.account_activation_title', locale: locale)

      # Choose password
      password = '1' * 8
      find("input[name='user[password]']").set(password)
      find("button[type='submit']").click

      save_and_open_page
      expect(page).to have_content I18n.t('devise.confirmations.confirmed', locale: locale)

      expect(Argument).to exist.with(feature: feature_name, benefit: benefit_description)
      expect(ProductGroup.all).to have(2).records
      expect(User.find_by_email('user@example.com').locale).to eq locale
    end
  end

  context 'default locale' do
    it_behaves_like 'Happy wizard path' do
      let(:locale) { 'en' }
    end
  end

  context 'language is changed' do
    before do
      visit '/'
      # open language menu
      find("img[alt='En']").click
      # change language to DA
      find("a[href='/language?lang=da']").click
    end

    it_behaves_like 'Happy wizard path' do
      let(:locale) { 'da' }
    end
  end
end
