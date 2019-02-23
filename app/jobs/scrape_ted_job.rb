class ScrapeTedJob < ApplicationJob
  queue_as :default

  def perform
    Inspiration.new(type: 'video', source:'ted')

  end

  # build url pour durée 1
  # récupérer les liens pour url de durée 1
  # créer les inspirations pour la durée 1
  # itérer pour toutes les durées


end
