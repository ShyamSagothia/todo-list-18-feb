class CreateCollaborations < ActiveRecord::Migration[8.0]
  def change
    create_table :collaborations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :todo_list, null: false, foreign_key: true

      t.timestamps
    end
  end
end
