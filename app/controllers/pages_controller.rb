class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home

  end

  def profile
    @user = current_user
    @seen_suggestions = current_user.suggestions.where(status:'seen').sort_by{|suggestion|suggestion.updated_at}.reverse
    @watchlist = current_user.suggestions.where(status:'watchlist').sort_by{|suggestion|suggestion.updated_at}.reverse
  end


end
