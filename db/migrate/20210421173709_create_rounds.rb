class CreateRounds < ActiveRecord::Migration[6.1]
  def change
    create_table :rounds do |t|
      t.string :category
      t.integer :position
      t.boolean :active, default: false
      t.boolean :completed, default: false
      t.string :round_type, default: "question"
      t.belongs_to :game, null: false, foreign_key: true

      t.timestamps
    end
  end
end
