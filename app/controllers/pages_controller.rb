class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home

  end

  def profile
    @user = current_user
    @seen_suggestions = current_user.suggestions.where(status:'seen').sort_by{|suggestion|suggestion.updated_at}.reverse
    @watchlist = current_user.suggestions.where(watchlisted: true).sort_by{|suggestion|suggestion.updated_at}.reverse
    @languageuserjoint = LanguageUserJoint.new

# check if languageuserjoint is created + how to remove label from the simple form

  end
#@Languageuserjoint = Languageuserjoint.create(profile_params)
  def profile_params
    params.require(:languageuserjoint).permit(:user_id, :language_id)
  end

end
