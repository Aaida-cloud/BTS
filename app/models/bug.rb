class Bug < ApplicationRecord
  require 'kaminari'
  paginates_per 5
  belongs_to :project
  belongs_to :developer, class_name: 'User', optional: true
  belongs_to :qa, class_name: 'User'
  has_one_attached :screenshot
  enum bug_type: { feature: 0, bug: 1 }
  enum status: { new_bug: 0, started: 1, resolved: 2 }
end
