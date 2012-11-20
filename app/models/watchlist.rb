class Watchlist < ActiveRecord::Base
  attr_accessible :user, :document, :notice

  belongs_to :user
  belongs_to :document

  after_create :log_watching_started
  after_destroy :log_watching_stopped

  private
  def log_watching_started
    WatchingStartedEvent.create!(for_user: user, external: document)
  end

  def log_watching_stopped
    WatchingStoppedEvent.create!(for_user: user, external: document)
  end
end
