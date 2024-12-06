class DocumentItem < ApplicationRecord
  belongs_to :case
  belongs_to :folder
  belongs_to :document

  has_one_attached :file

  def short_file_name
    base_name = File.basename(file_name)
    extension = File.extname(file_name)

    if base_name.size > 22
      "#{base_name[..20]}...#{extension[1..]}"
    else
      file_name
    end
  end

  def type
    return :primary if is_primary
    return :attachment if is_attachment
    return :transactional if is_transactional
    :other
  end

  def file_type
    case file.content_type
    when "application/pdf"
      "PDF-Dokument"
    when "application/zip"
      "ZIP-Archiv"
    when "text/plain"
      "Text-Datei"
    when "text/html"
      "HTML-Dokument"
    when "image/png"
      "PNG-Bild"
    when "application/pkcs7-signature"
      "Elektronische Signatur"
    else
      file.content_type
    end
  end

  def self.default_order
    DocumentItem.order(is_primary: :desc, is_attachment: :desc, is_transactional: :asc, file_name: :asc)
  end
end
