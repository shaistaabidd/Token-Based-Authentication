class AddPasswordConfirmationFieldInUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :password_confirmation, :string
  end
end