class CreateGigs < ActiveRecord::Migration[6.1]
  def change
    create_table :gigs do |t|
      t.string :name
      t.text :description
      t.decimal :amount
      t.integer :review_count
      t.string :average_star
      t.integer :user_id
      t.timestamps
    end
  end
end
