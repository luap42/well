class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :cases, foreign_key: :manager
  has_many :tasks

  def display_name
    return email if full_name.blank?
    full_name
  end

  def representments
    Representment.current.where(to_user: self)
  end

  def manager_of?(case_)
    case_.manager.id == self.id
  end
end
