module AuthenticationConcern
  extend ActiveSupport::Concern

  def active_for_authentication?
    super && enabled?
  end

  def inactive_message
    enabled? ? super : :account_disabled
  end
end
