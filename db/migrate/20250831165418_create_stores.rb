class CreateStores < ActiveRecord::Migration[7.1]
  def change
    create_table :stores do |t|
      t.string :name
      t.string :access_token, null: false
      
      t.timestamps
    end
  end
end
