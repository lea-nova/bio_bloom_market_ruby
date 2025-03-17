class PagesController < ApplicationController
  # skip_before_action :authenticate_user!, only: [:home]
  allow_unauthenticated_access  only: [:home]
  def home
  end
end
