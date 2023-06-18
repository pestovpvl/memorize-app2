class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :set_locale, :memory_systems

  private

  def memory_systems
    memory_systems = {
      "Leitner System" => 'The Leitner system is a widely used method of efficiently using flashcards that was proposed by the German science journalist Sebastian Leitner in the 1970s. It is a simple implementation of the principle of spaced repetition, where cards are reviewed at increasing intervals.'
    }
    @memory_systems = memory_systems
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
