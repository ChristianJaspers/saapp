require 'rails_helper'

feature 'Billing form' do
  let(:manager) { create(:user, :manager) }
  let(:pages_to_visit) do
    %w[
      /
      /manager
      /manager/product_groups
      /manager/users
      /manager/reports
      /manager/reports/user_activity
      /manager/reports/argument_ranking
    ]
  end

  feature 'User visits all pages as manager' do
    background do
      page.set_rack_session("warden.user.user.key" => User.serialize_into_session(manager).unshift("User"))
      allow_any_instance_of(CompanySubscription).to receive(:can_use_system?).and_return(can_use_system)
      allow_any_instance_of(CompanySubscription).to receive(:display_reminder?).and_return(true)
      allow_any_instance_of(Saasy::BillingLinkNegotiator).to receive(:render_form?).and_return(render_form)
      allow_any_instance_of(CompanySubscription).to receive(:active_subscription).and_return(double(days_until_expires: 7))
      allow_any_instance_of(CompanySubscription).to receive(:latest_subscription).and_return(double(expired?: true))
    end

    feature do
      let(:can_use_system) { true }
      let(:render_form) { true }

      scenario js: true do
        pages_to_visit.each do |page_to_visit|
          visit page_to_visit
          expect(page).to have_selector('form[id="external_billing_system"]')
          expect(page).to have_selector("a[href=\"javascript:$('#external_billing_system').submit()\"]")
        end
      end
    end

    feature do
      let(:can_use_system) { false }
      let(:render_form) { true }

      scenario js: true do
        pages_to_visit.each do |page_to_visit|
          visit page_to_visit
          expect(page).to have_selector('form[id="external_billing_system"]')
          expect(page).to have_selector("a[href=\"javascript:$('#external_billing_system').submit()\"]")
        end
      end
    end

    feature do
      background do
        allow_any_instance_of(Saasy::BillingLinkNegotiator).to receive(:saasy_subscription_link).and_return("http://pay.me")
      end

      feature do
        let(:can_use_system) { true }
        let(:render_form) { false }

        scenario js: true do
          pages_to_visit.each do |page_to_visit|
            visit page_to_visit
            expect(page).to_not have_selector('form[id="external_billing_system"]')
            expect(page).to have_selector("a[href=\"http://pay.me\"]")
          end
        end
      end

      feature do
        let(:can_use_system) { false }
        let(:render_form) { false }

        scenario js: true do
          pages_to_visit.each do |page_to_visit|
            visit page_to_visit
            expect(page).to_not have_selector('form[id="external_billing_system"]')
            expect(page).to have_selector("a[href=\"http://pay.me\"]")
          end
        end
      end
    end
  end
end
