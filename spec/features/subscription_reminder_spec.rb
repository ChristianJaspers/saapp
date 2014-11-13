require 'rails_helper'

feature 'Subscription visual reminder' do
  let(:expected_reminder_content) { I18n.t('subscriptions.trial_subscription_will_expire_within_week', days: days) }
  let(:manager) { create(:user, :manager) }
  let(:pages_to_visit) do
    %w[
      /manager
      /manager/product_groups
      /manager/users
      /manager/reports
      /manager/reports/user_activity
      /manager/reports/argument_ranking
    ]
  end

  feature 'User visits his account pages as manager' do
    let(:days) { 7 }

    background do
      page.set_rack_session("warden.user.user.key" => User.serialize_into_session(manager).unshift("User"))
      allow_any_instance_of(CompanySubscription).to receive(:can_use_system?).and_return(true)
    end

    feature 'and his subscription is about to end within week' do
      background do
        allow_any_instance_of(CompanySubscription).to receive(:display_reminder?).and_return(true)
        allow_any_instance_of(CompanySubscription).to receive(:active_subscription).and_return(double(days_until_expires: days))
      end

      scenario js: true do
        pages_to_visit.each do |page_to_visit|
          visit page_to_visit
          expect(page).to have_content(expected_reminder_content)
        end
      end
    end

    feature 'and his subscription is about to end within more than week' do
      background do
        allow_any_instance_of(CompanySubscription).to receive(:display_reminder?).and_return(false)
      end

      scenario js: true do
        pages_to_visit.each do |page_to_visit|
          visit page_to_visit
          expect(page).to_not have_content(expected_reminder_content)
        end
      end
    end
  end
end
