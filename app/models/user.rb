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

  belongs_to :banned_ip, :foreign_key => :last_sign_in_ip, :primary_key => :ip

  def label
    name
  end

  def already_voted_for?(comment, up_or_down)
    votings.find_by_comment_id(comment.id)
  end

  def vote_for(comment, up_or_down)
    votings.create(:comment => comment, :up_or_down => up_or_down)
    case up_or_down
      when :up then comment.update_attributes(:votes => comment.votes + 1)
      when :down then comment.update_attributes(:votes => comment.votes - 1)
    end
  end

  def self.find_for_authentication(conditions)
    super(conditions.merge(:banned => false))
  end
end
