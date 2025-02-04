class Bug < ApplicationRecord
  belongs_to :project
  # TODO
  # belongs_to :user

  has_one_attached :screenshot

  enum bug_type: { feature: 0, bug: 1 }
  enum status: { new_bug: 0, started: 1, resolved: 3 }

end
