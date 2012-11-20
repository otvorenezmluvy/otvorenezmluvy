# encoding: utf-8
class NotificationMailer < ActionMailer::Base
  default :from => "otvorenezmluvy@gmail.com"

  def flagged_comment_warning(comment)
    @comment = comment
    mail(:to => "admin@otvorenezmluvy.sk", :subject => "[OtvoreneZmluvy] Nevhodný komentár na stránke")
  end
end
