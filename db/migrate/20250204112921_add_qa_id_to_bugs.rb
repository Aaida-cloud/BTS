class AddQaIdToBugs < ActiveRecord::Migration[7.2]
  def change
    add_column :bugs, :qa_id, :bigint
  end
end
