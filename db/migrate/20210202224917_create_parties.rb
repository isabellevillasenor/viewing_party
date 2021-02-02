class CreateParties < ActiveRecord::Migration[5.2]
  def change
    create_table :movies do |t|
      t.string :api_ref
      t.string :title
    end
    
    create_table :parties do |t|
      t.datetime :party_time
      t.integer :party_duration
      t.references :host, foreign_key: { to_table: :users }
      t.references :movie, foreign_key: true

      t.timestamps
    end
  end
end
