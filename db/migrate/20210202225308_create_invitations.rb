class CreateInvitations < ActiveRecord::Migration[5.2]
  def change
    create_table :invitations do |t|
      t.references :party_person, foreign_key: { to_table: :users }
      t.references :party, foreign_key: true
    end
  end
end
