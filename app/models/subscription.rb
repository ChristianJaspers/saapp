class Subscription < ActiveRecord::Base
  belongs_to :company
  belongs_to :referrer, class_name: User
end
