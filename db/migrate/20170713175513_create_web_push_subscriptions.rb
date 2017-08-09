class CreateWebPushSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :web_push_subscriptions do |t|
      t.string :endpoint, null: false
      t.string :key_p256dh, null: false
      t.string :key_auth, null: false

      # use longtext type instead of json
      t.text :data, :limit => 4294967295

      t.timestamps
    end
  end
end
