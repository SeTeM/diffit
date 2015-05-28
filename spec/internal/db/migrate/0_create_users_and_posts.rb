class CreateUsersAndPosts < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :login

      t.timestamps null: false
    end

    create_table :posts do |t|
      t.string :title
      t.datetime :posted_at

      t.timestamps null: false
    end
  end
end
