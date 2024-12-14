class TaskResolutionType < ApplicationRecord
  default_scope { where(is_enabled: true) }
end
