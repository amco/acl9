class CreateTables < ActiveRecord::Migration[5.0]
  def change
    create_table :roles do |t|
      t.string   :name,              :limit => 40
      t.boolean  :system
      t.string   :authorizable_type, :limit => 40
      t.integer  :authorizable_id
      t.timestamps null: false
    end

    add_index :roles, [:authorizable_type, :authorizable_id]

    create_table :roles_users, id: false do |t|
      t.references  :user
      t.references  :role
    end
    
    create_table :users do |t|
      t.string :name
      t.timestamps null: false
    end

    create_table :foos do |t|
      t.string :name
      t.timestamps null: false
    end

    create_table :bars do |t|
      t.string :name
      t.timestamps null: false
    end

    create_table :uuids, id: false do |t|
      t.string :uuid, primary_key: true
      t.string :name
      t.timestamps null: false
    end

    create_table :accounts do |t|
      t.string :name
      t.timestamps null: false
    end

    create_table :accesses do |t|
      t.string :name
      t.boolean  :system
      t.string   :authorizable_type, :limit => 40
      t.integer  :authorizable_id
      t.timestamps null: false
    end

    add_index :accesses, [:authorizable_type, :authorizable_id]

    create_table :accesses_accounts, id: false do |t|
      t.references  :account
      t.references  :access
    end

    create_table :foo_bars do |t|
      t.string :name
      t.timestamps null: false
    end


    create_table :other_roles do |t|
      t.string   :name,              :limit => 40
      t.boolean  :system
      t.string   :authorizable_type, :limit => 40
      t.integer  :authorizable_id
      t.timestamps null: false
    end

    add_index :other_roles, [:authorizable_type, :authorizable_id]

    create_table :other_roles_users, id: false do |t|
      t.references  :user
      t.references  :role
    end
    
    create_table :other_users do |t|
      t.string :name
      t.timestamps null: false
    end

    create_table :other_foos do |t|
      t.string :name
      t.timestamps null: false
    end
  end
end
