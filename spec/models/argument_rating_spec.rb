require 'rails_helper'

describe ArgumentRating do
  it { should validate_uniqueness_of(:argument_id).scoped_to(:rater_id) }
end
