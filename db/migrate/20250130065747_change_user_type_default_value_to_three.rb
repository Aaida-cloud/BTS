class ChangeUserTypeDefaultValueToThree < ActiveRecord::Migration[7.2]
  def change
    change_column_default :users, :user_type, from: nil, to: 3
  end
end
