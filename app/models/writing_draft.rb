class WritingDraft < ApplicationRecord
  belongs_to :case
  belongs_to :user
  belongs_to :participant, required: false
  belongs_to :document_item, required: false
  belongs_to :writing_type

  has_many :writing_cosignatures

  has_rich_text :content
  default_scope { where.not(is_deleted: true) }

  def cosignature_to_input
    writing_cosignatures.where(is_obsoleted: false, is_given: false, is_pending: true).map do |cs|
      "#{cs.user.shortcode}: #{cs.request}"
    end.join("\n")
  end

  def input_to_cosignatures(input)
    open_cosignatures = writing_cosignatures.where(is_obsoleted: false, is_given: false, is_pending: true)
    cosignature_ids = open_cosignatures.all.map { |cs| cs.id }

    input.split("\n").each do |line|
      line = line.split(":", 2)
      user_code = line[0].strip
      request = line.size == 2 ? line[1].strip : nil

      user = User.where(shortcode: user_code)

      if user.any?
        user = user.first
        if open_cosignatures.where(user: user).any?
          cosig = open_cosignatures.where(user: user).first
          cosig.update!(
            request: request,
          )
          cosignature_ids.delete(cosig.id)
        else
          WritingCosignature.create!(
            user: user,
            writing_draft: self,
            request: request,
            response: nil, given_at: nil,
            is_obsoleted: false, is_given: false, is_pending: true
          )
        end
      end
    end

    cosignature_ids.each do |cid|
      writing_cosignatures.find(cid).destroy!
    end
  end
end
