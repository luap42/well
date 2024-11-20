class Folder < ApplicationRecord
  belongs_to :case
  has_many :documents
end
