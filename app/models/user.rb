class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def display_name
    return email if full_name.blank?

    "#{full_name} (#{email})"
  end

  def representments
    Representment.where(to_user: self, when: ..Date.today).order(priority: :desc, when: :asc)
  end
end
