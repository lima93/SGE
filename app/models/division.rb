class Division < ApplicationRecord
  validates :name, :description, presence: true

  belongs_to :department
  has_many :division_users, dependent: :destroy
  has_many :divisions, through: :division_users
  has_many :users, through: :division_users
  has_many :roles, through: :division_users

  def self.search(search)
    if search
      where('unaccent(name) ILIKE unaccent(?)',
            "%#{search}%").order('name ASC')
    else
      order('name ASC')
    end
  end

  def self.not_in_user(department, div)
    User.where(id: department.users).where.not(id: div.users)
  end
end