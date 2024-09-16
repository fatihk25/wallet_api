class CreateSessions < ActiveRecord::Migration[7.2]
  def change
    create_table :sessions do |t|
      t.string :token, null: false
      t.references :entity, polymorphic: true, null: false, index: true
      t.timestamps
    end
    add_index :sessions, :token, unique: true
  end
end
