class CreateCharacters < ActiveRecord::Migration[7.0]
  def change
    create_table :characters do |t|
      t.string :name
      t.text :description
      t.string :path
      t.string :extension

      t.timestamps
    end
  end
end
