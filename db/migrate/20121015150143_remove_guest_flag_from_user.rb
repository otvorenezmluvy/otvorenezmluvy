class RemoveGuestFlagFromUser < ActiveRecord::Migration
  def change
    add_column :question_answers, :guest_user_id, :bigint
    QuestionAnswer.all.each do |qa|
      if !qa.user.nil? && qa.user.email.match(/guest_(\d+)@*/)
        qa.guest_user_id = $1
        qa.save
      end
    end
    ActiveRecord::Base.connection.execute("DELETE FROM users WHERE email LIKE 'guest_%'")
    remove_column :users, :guest
  end
end
