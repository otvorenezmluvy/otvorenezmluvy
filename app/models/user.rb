require 'digest'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :name, :password, :password_confirmation, :remember_me, :admin, :expert, :terms_of_service

  validates_presence_of :name
  validates_acceptance_of :terms_of_service

  has_many :comments
  has_many :question_answers
  has_many :votings
  has_many :watchlists

  has_many :watched_documents, through: :watchlists, class_name: 'Document', source: :document
  has_many :stream_events, class_name: 'Event', foreign_key: :for_user_id

  has_many :document_openings

  belongs_to :banned_ip, :foreign_key => :last_sign_in_ip, :primary_key => :ip

  scope :name_or_email_contains, lambda { |query| where(['LOWER(name) LIKE LOWER(?) OR LOWER(email) LIKE LOWER(?)', "%#{query}%", "%#{query}%"]) }

  after_create :log_user_registered

  def label
    name
  end

  def guest
    false
  end

  def already_voted_for?(comment, up_or_down)
    votings.find_by_comment_id(comment.id)
  end

  def vote_for(comment, up_or_down)
    comment.votings.create(:up_or_down => up_or_down, user: self)
    case up_or_down
      when :up then comment.update_attributes(:votes => comment.votes + 1)
      when :down then comment.update_attributes(:votes => comment.votes - 1)
    end
  end

  def self.find_for_authentication(conditions)
    super(conditions.merge(:banned => false))
  end

  def watch(document, notice)
    watched_document = watched_document(document)
    if watched_document
      watched_document.update_attributes(notice: notice)
    else
      watchlists.create(document: document, notice: notice)
      Configuration.documents_repository.save(document) # TODO update API
    end
  end

  def unwatch(document)
    watched_document(document).destroy
    Configuration.documents_repository.save(document) # TODO update API
  end

  def watched_document(document)
    watchlists.where(document_id: document.id).first
  end

  def watching?(document)
    watched_document(document)
  end

  def notice_for(document)
    watched_document(document).try(:notice)
  end

  def stream_filters
    {
        show_watching: stream_show_watching,
        show_my_comments: stream_show_my_comments,
        show_other_comments: stream_show_other_comments,
        show_openings: stream_show_openings,
        show_answers: stream_show_answers,
    }
  end

  def dashboard_events
    allowed_events = [UserRegisteredEvent]
    allowed_events += [WatchingStartedEvent, WatchingStoppedEvent] if stream_show_watching?
    allowed_events += [MyCommentEvent] if stream_show_my_comments?
    allowed_events += [OthersCommentEvent] if stream_show_other_comments?
    allowed_events += [DocumentOpenedEvent] if stream_show_openings?
    allowed_events += [QuestionAnswerEvent] if stream_show_answers?
    stream_events.where(type: allowed_events.collect(&:to_s)).order('updated_at DESC')
  end

  def select_watched_documents(documents)
    documents = watchlists.where(document_id: documents.collect(&:id))
    WatchedDocuments.new(documents)
  end

  # Events
  def log_document_opened(document)
    unless document_openings.where(document_id: document.id).exists?
      document_openings.create(document_id: document.id)
      Configuration.documents_repository.save(document) # TODO update API
    end

    return unless watched_documents.include?(document)
    recently_opened = DocumentOpenedEvent.where('updated_at >= ?', 30.minutes.ago).where(for_user_id: self.id, external_id: document.id).first
    if recently_opened
      recently_opened.touch
    else
      DocumentOpenedEvent.create!(for_user: self, external: document)
    end
  end

  def log_comment_added(comment)
    MyCommentEvent.create!(for_user: self, comment: comment)
    comment.document.watchers.each do |watcher|
      OthersCommentEvent.create!(for_user: watcher, comment: comment) if watcher != self
    end
  end

  def log_question_answered(question_answer)
    QuestionAnswerEvent.create!(for_user: self, external: question_answer)
  end

  def log_user_registered
    UserRegisteredEvent.create!(for_user: self, external: self)
  end

  class WatchedDocuments
    def initialize(watchlists)
      @notices = watchlists.inject({}) { |notices, watchlist| notices[watchlist.document_id] = watchlist.notice; notices }
    end

    def include?(document)
      @notices.include?(document.id)
    end

    def notice_for(document)
      @notices[document.id]
    end
  end
end
