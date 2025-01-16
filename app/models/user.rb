class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  if Rails.env.production?
    devise :database_authenticatable, :rememberable, :validatable
  else
    devise :database_authenticatable, :rememberable, :validatable, :registerable
  end

  has_many :cases, foreign_key: :manager
  has_many :tasks
  has_many :writing_types
  has_many :time_records

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

  def writing_type(token)
    writing_types.where(default_token: token.to_s).first
  end

  def letter_style_writing_types
    writing_types.where(default_token: nil, has_recipient: true)
  end

  def directive_style_writing_types
    writing_types.where(default_token: nil, has_recipient: false)
  end

  def ensure_default_writing_types!
    WritingType.create!(
      user: self,
      title: "Schreiben",
      default_token: "letter",
      has_recipient: true,
      has_cosigning_required: false,
      is_enabled: true
    ) unless writing_types.where(default_token: "letter").any?

    WritingType.create!(
      user: self,
      title: "Verfügung",
      default_token: "directive",
      has_recipient: false,
      has_cosigning_required: false,
      is_enabled: true
    ) unless writing_types.where(default_token: "directive").any?
  end
end
