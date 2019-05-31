class UsersDocument < ApplicationRecord
  belongs_to :document
  belongs_to :user

  accepts_nested_attributes_for :user

  validates :user, uniqueness: { scope: :document }
  validates :function, :user_id, presence: true

  def self.user_owner?(users_documents, user)
    users_documents.each do |ud|
      if ud.user == user && ud.owner?
        puts "aqui"
        return true
      end
    end
    false
  end

  def self.toggle_subscription(user)
    user.subscription = true
    user.save
  end
end
