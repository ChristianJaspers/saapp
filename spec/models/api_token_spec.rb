require 'rails_helper'

describe ApiToken do
  subject { create(:api_token) }

  its(:access_token) { should_not be_nil }
end
