class CreateQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.belongs_to :round, null: false, foreign_key: true
      t.string :text
      t.string :answer
      t.string :url
      t.integer :position

      t.timestamps
    end
  end
end
