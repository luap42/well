class Folder < ApplicationRecord
  belongs_to :case
  has_many :documents

  def printable_name
    name.gsub(/[^a-zA-Z0-9-]+/, "_")
  end
end
