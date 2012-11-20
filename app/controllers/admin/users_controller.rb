# encoding: utf-8
class Admin::UsersController < AdminController
  authorize_resource

  def index
    @query = params[:q]
    @users = User.order('id ASC')
    @users = @users.name_or_email_contains(@query) unless @query.blank? # TODO replace with fulltext
    @users = @users.page(params[:page])
  end

  def update
    user = User.find(params[:id])
    user.update_attributes(params[:user])
    redirect_to admin_users_path, notice: "Zmena používateľa #{user.name} bola úspešná."
  end

  def ban
    if(request.post?)
      user = User.find(params[:id])
      user.banned = true
      user.save
      redirect_to admin_users_path
    end
  end

  def unban
    if(request.post?)
      user = User.find(params[:id])
      user.banned = false
      user.save
      redirect_to admin_users_path
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
    redirect_to admin_users_path
  end
end
