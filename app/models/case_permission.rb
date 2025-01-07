class CasePermission < ApplicationRecord
  belongs_to :case
  belongs_to :user
  belongs_to :case_permission_type

  def permission? (rule)
    case_permission_type.grants? rule
  end
end
