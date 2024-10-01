class CaseType < ApplicationRecord
  default_scope { where(enabled: true) }
end
