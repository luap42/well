class CasePermission < ApplicationRecord
  belongs_to :case
  belongs_to :user
  belongs_to :permission_type

  def permission? (rule)
    permission_type.grants? rule
  end
end
