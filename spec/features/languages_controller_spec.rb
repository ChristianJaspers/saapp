require 'rails_helper'

feature 'Changing language' do
  context 'guest access' do
    scenario 'guest chooses en', js: true do
      visit '/'
      find("img[alt='En']").click
      find("a[href='/language?lang=en']").click
      expect(current_path).to eq '/'
    end

    scenario 'guest chooses da', js: true do
      visit '/'
      find("img[alt='En']").click
      find("a[href='/language?lang=da']").click
      expect(current_path).to eq '/da'
    end
  end

  context 'manager access' do
    let(:manager) { create(:manager) }

    before do
      page.set_rack_session("warden.user.user.key" => User.serialize_into_session(manager).unshift("User"))
    end

    scenario 'manager chooses en', js: true do
      visit '/'
      expect(page).to have_content(manager.email)
      find("img[alt='En']").click
      find("a[href='/language?lang=en']").click
      expect(current_path).to eq '/'
    end

    scenario 'manager chooses da', js: true do
      visit '/'
      expect(page).to have_content(manager.email)
      find("img[alt='En']").click
      find("a[href='/language?lang=da']").click
      expect(current_path).to eq '/da'
    end
  end
end
