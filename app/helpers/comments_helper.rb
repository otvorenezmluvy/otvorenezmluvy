module CommentsHelper
  def gravatar_url(user)
    email = user.try(:email) || 'ano.nym.ous'
    "http://www.gravatar.com/avatar.php?gravatar_id=#{Digest::MD5::hexdigest(email)}"
  end
end
