class Bug < ApplicationRecord
  require 'kaminari'

  validates :title, presence: true
  validates :description, presence: true
  validates :deadline, :bug_type, :status, presence: true

  belongs_to :project
  belongs_to :developer, class_name: 'User', optional: true
  belongs_to :qa, class_name: 'User'

  has_one_attached :screenshot

  enum bug_type: { feature: 0, bug: 1 }
  enum status: { new_bug: 0, started: 1, resolved: 2 }

  BUG_TYPES = [
    ['Feature', 'feature'],
    ['Bug', 'bug']
  ]

  STATUS_TYPES = [
    ['New', 'new_bug'],
    ['Started', 'started'],
    ['Resolved', 'resolved']
  ]
end
