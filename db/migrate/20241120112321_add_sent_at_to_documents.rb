class AddSentAtToDocuments < ActiveRecord::Migration[7.2]
  def change
    add_column :documents, :sent_at, :date
  end
end
