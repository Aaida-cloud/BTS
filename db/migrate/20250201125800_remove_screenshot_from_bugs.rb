class RemoveScreenshotFromBugs < ActiveRecord::Migration[7.2]
  def change
    remove_column :bugs, :screenshot, :string
  end
end
