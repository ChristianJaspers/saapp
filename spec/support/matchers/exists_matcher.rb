RSpec::Matchers.define :exist do
  match do |actual|
    actual.exists?(@conditions_hash || {})
  end

  chain(:with) { |conditions_hash| @conditions_hash = conditions_hash }
end
