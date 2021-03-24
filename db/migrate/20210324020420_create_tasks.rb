class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :name
      t.string :description
      t.date :due_date
      t.integer :priority
      t.integer :iscomplete

      t.timestamps
    end
  end
end
