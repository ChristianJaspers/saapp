RSpec::Matchers.define :exist do
  match do |actual|
    if actual.is_a? Class
      actual.unscoped.exists?(@conditions_hash || {})
    else
      actual.class.unscoped.exists?(actual.id)
    end
  end

  chain(:with) { |conditions_hash| @conditions_hash = conditions_hash }
end
