class UsersController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]
  before_action :ensure_guest_user, only: [:edit, :update]
  def index
    @user = current_user
    @users = User.all
    @book = Book.new

  end

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "You have updated user successfully."
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  # 指定日の投稿数を表示
  def search
    user = User.find(params[:user_id])
    @books = user.books.where(created_at: params[:created_at].to_date.all_day)
    render :daily_posts_form
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)

  end

  def is_matching_login_user
    user = User.find(params[:id])
    unless user.id == current_user.id
        redirect_to user_path(current_user.id)
    end
  end

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.guest_user?
      redirect_to user_path(current_user), notice: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
    end
  end
end
