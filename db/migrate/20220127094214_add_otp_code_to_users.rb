class AddOtpCodeToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :test_otp_code, :string
  end
end
