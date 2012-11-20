module CommentsHelper
  def gravatar_url(user)
    if user.try(:email)
      "http://www.gravatar.com/avatar.php?gravatar_id=#{Digest::MD5::hexdigest(user.email)}"
    else
      asset_path "avatar.png"
    end
  end

  def link_to_comment(name, comment)
    link_to name, document_path(comment.document, anchor: dom_id(comment))
  end
end
