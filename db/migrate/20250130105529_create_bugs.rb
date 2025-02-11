class CreateBugs < ActiveRecord::Migration[7.2]
  def change
    create_table :bugs do |t|
      t.string :title
      t.text :description
      t.date :deadline
      t.integer :bug_type
      t.integer :status
      t.string :screenshot
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
