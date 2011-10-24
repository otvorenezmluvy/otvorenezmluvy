class UsersController < AuthorizedController
  before_filter :set_body_class
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    sql = <<-SQL
    SELECT * FROM comments c
    WHERE c.user_id = #{@user.id}
    AND c.document_id IN
    (SELECT document_id
    FROM comments q
    WHERE q.user_id = #{@user.id}
    group by document_id
    order by max(created_at)
    LIMIT 5)
    LIMIT 5;
   SQL
    @recent_comments = Comment.find_by_sql(sql)
    @recent_question_answers = @user.question_answers.select("document_id, max(created_at) as created_at").group("document_id").order("max(created_at)").limit(5)
  end

  def update
    user = User.find(params[:id])
    user.update_attributes(params[:user])
    redirect_to users_path
  end

  def ban
    if(request.post?)
      user = User.find(params[:id])
      user.banned = true
      user.save
      redirect_to users_path
    end
  end

  def unban
    if(request.post?)
      user = User.find(params[:id])
      user.banned = false
      user.save
      redirect_to users_path
    end
  end

  def ban_ip
    if(request.get?)
      user = User.find(params[:id])
      @users = User.select("name,email").where(:last_sign_in_ip => user.last_sign_in_ip)
      render :json => @users
    else
      user = User.find(params[:id])
      banned_ip = BannedIp.find_or_create_by_ip(user.last_sign_in_ip, :creator_id => current_user.id)
      render :json => banned_ip
    end
  end

  def unban_ip
    user = User.find(params[:id])
    user.banned_ip.try(:destroy)
    redirect_to users_path
  end

  def set_body_class
    @body_class = "detail user" unless action_name == "index"
  end
end
