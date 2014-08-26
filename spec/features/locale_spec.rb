require 'rails_helper'

feature 'Locale' do
  after do
    delete_cookie('lang')
  end

  context 'user is a guest' do
    context 'my web browser is EN' do
      scenario 'en guest visits / path', js: true do
        expect(get_me_the_cookie('lang')).to be_nil
        visit '/'
        expect(current_path).to eq '/'
        expect(get_me_the_cookie('lang')[:value]).to eq 'en'
      end

      scenario 'en guest visits /da path', js: true do
        expect(get_me_the_cookie('lang')).to be_nil
        visit '/da'
        expect(current_path).to eq '/'
        expect(get_me_the_cookie('lang')[:value]).to eq 'en'
      end

      context 'guest already was here and chose en language' do
        before { create_cookie('lang', 'en') }

        scenario 'en guest visits cms page' do
          visit '/login'
          expect(current_path).to eq '/login'
        end

        scenario 'en guest visits cms page with params' do
          visit '/login?param=1'
          expect(current_url.sub(current_host, '')).to eq '/login?param=1'
        end

        scenario 'en guest visits cms page with incorrect locale' do
          visit '/da/login'
          expect(current_path).to eq '/login'
        end

        scenario 'en guest visits cms page with params and incorrect locale' do
          visit '/da/login?param=1'
          expect(current_url.sub(current_host, '')).to eq '/login?param=1'
        end
      end
    end

    context 'my web browser is DA' do
      before do
        Capybara.current_session.driver.header 'Accept-Language', 'da-DK,en-us;q=0.8,en;q=0.6'
      end

      after do
        Capybara.current_session.driver.header 'Accept-Language', nil
      end

      scenario 'da guest visits / path', js: true do
        expect(get_me_the_cookie('lang')).to be_nil
        visit '/'
        expect(current_path).to eq '/da'
        expect(get_me_the_cookie('lang')[:value]).to eq 'da'
      end

      context 'guest already was here and chose da language' do
        before { create_cookie('lang', 'da') }

        scenario 'da guest visits cms page' do
          visit '/login'
          expect(current_path).to eq '/da/login'
        end

        scenario 'da guest visits cms page with params' do
          visit '/login?param=1'
          expect(current_url.sub(current_host, '')).to eq '/da/login?param=1'
        end

        scenario 'da guest visits cms page with correct locale' do
          visit '/da/login'
          expect(current_path).to eq '/da/login'
        end

        scenario 'da guest visits cms page with params and correct locale' do
          visit '/da/login?param=1'
          expect(current_url.sub(current_host, '')).to eq '/da/login?param=1'
        end
      end
    end
  end

  context 'user is a manager' do
    let(:manager) { create(:manager) }

    before do
      allow_any_instance_of(User).to receive(:locale).and_return('da')
      page.set_rack_session("warden.user.user.key" => User.serialize_into_session(manager).unshift("User"))
    end

    context 'my web browser is EN' do
      scenario 'manager visits / path', js: true do
        visit '/'
        expect(current_path).to eq '/da'
      end

      scenario 'manager visits /da path', js: true do
        visit '/da'
        expect(current_path).to eq '/da'
      end
    end

    context 'my web browser is DA' do
      before do
        Capybara.current_session.driver.header 'Accept-Language', 'da-DK,en-us;q=0.8,en;q=0.6'
      end

      after do
        Capybara.current_session.driver.header 'Accept-Language', nil
      end

      scenario 'manager visits / path', js: true do
        visit '/'
        expect(current_path).to eq '/da'
      end
    end
  end
end
