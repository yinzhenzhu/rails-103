class GroupsController < ApplicationController
  before_action :authenticate_user! , only: [:new, :create]
  before_action :find_group_and_check_permission, only: [:edit, :update, :destroy]
  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end
  def show
    @group = Group.find(params[:id])
    @posts = @group.posts.recent.paginate(:page => params[:page], :per_page => 5)
  end

  def edit

  end
  def join
    @group = Group.find(params[:id])
    if !current_user.is_member_of?(@group)
      current_user.join!(@group)
      flash[:notice] = "加入本讨论组成功"
    else
      flash[:alert] = "你已经是本讨论组成员了"
    end
    redirect_to group_path(@group)
  end

  def quit
    @group = Group.find(params[:id])
    if current_user.is_member_of?(@group)
      current_user.quit!(@group)
      flash[:alert] = "你已成功退出本讨论组"
    else
      flash[:warning] = "你不是本讨论组成员，怎么退出"
    end
    redirect_to group_path(@group)
  end


    def create
    @group = Group.new(group_params)
    @group.user = current_user
    if @group.save
    redirect_to groups_path
  else
    render :new
  end
end


  def update


     if @group.update(group_params)
    redirect_to groups_path , notice: "update success"
 else
   render :edit
 end
end
  def destroy


    @group.destroy
    redirect_to groups_path
    flash[:alert] = "group deleted"
  end








private

  def group_params
    params.require(:group).permit(:title, :description)
  end

  def find_group_and_check_permission

    @group = Group.find(params[:id])
    if current_user != @group.user
      redirect_to root_path, alert: "you have no permission"
    end
  end


end
