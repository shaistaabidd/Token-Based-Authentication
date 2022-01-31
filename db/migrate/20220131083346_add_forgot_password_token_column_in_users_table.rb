class AddForgotPasswordTokenColumnInUsersTable < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :password_token, :string
  end
end
