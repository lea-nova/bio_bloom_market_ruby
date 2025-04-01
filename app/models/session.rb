class Session < ApplicationRecord
  belongs_to :user
  def create
    reset_session
  end
end
