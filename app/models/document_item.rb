class DocumentItem < ApplicationRecord
  belongs_to :case
  belongs_to :folder
  belongs_to :document

  has_one_attached :file

  def type
    return :primary if is_primary
    return :attachment if is_attachment
    return :transactional if is_transactional
    :other
  end

  def self.default_order
    DocumentItem.order(is_primary: :desc, is_attachment: :desc, is_transactional: :asc, file_name: :asc)
  end
end
