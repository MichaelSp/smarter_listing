class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.string :name
      t.string :content
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
