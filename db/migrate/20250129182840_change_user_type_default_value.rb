class ChangeUserTypeDefaultValue < ActiveRecord::Migration[7.2]
  def change
    change_column_default :users, :user_type, default: 0
  end
end
