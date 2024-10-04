class CreateParticipants < ActiveRecord::Migration[7.2]
  def change
    create_table :participants do |t|
      t.timestamps
      t.references :case
      t.references :participant_role
      t.string :name
      t.text :address_field
      t.text :contact_details
      t.string :email
      t.string :tel_no
      t.string :mobile_no
      t.string :fax_no
      t.text :comment
      t.boolean :outdated
      t.boolean :provide_as_template
    end
  end
end
