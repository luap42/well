class TimeRecord < ApplicationRecord
  belongs_to :user
  belongs_to :case

  def duration
    return nil if running
    ends_at - begins_at
  end

  def self.current_for_case_and_user(case_, user)
    TimeRecord.where(case: case_, user: user, running: true).first
  end

  def self.has_current_for_case_and_user?(case_, user)
    TimeRecord.where(case: case_, user: user, running: true).any?
  end

  def self.current_for_user(user)
    TimeRecord.where(user: user, running: true).first
  end

  def self.has_current_for_user?(user)
    TimeRecord.where(user: user, running: true).any?
  end
end
