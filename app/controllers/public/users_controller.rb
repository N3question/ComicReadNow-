class Public::UsersController < ApplicationController
  before_action :authenticate_user!, except: [:rank_index]
  
  def my_page
    session["url"] = nil
    session["search_keyword"] = nil
    
    users = User.where(is_deleted: false).sort { |a, b| b.read_judgements.where(can_read: true).count + b.update_count <=> a.read_judgements.where(can_read: true).count + a.update_count}
    
    # 順位の表示
    default = 1 
    
    ## 該当のuserがヒットするまでeachを回し続ける
    users.each do |user| 
      if user_signed_in? && user.id == current_user.id
        @my_rank = default # 13行目と＝じゃない
      end
      # 一周すると+1
      default += 1 
    end
  end
  
  def edit
  end
  
  def update
    if current_user.update(user_params)
      flash[:notice] = "ユーザ情報を変更しました。"
      redirect_to my_page_path
    else
      render :edit
    end
  end
  
  # ユーザ退会機能  
  def unsubscribe
    user = current_user
    user.update(is_deleted: true)
    reset_session
    flash[:notice] = "退会が完了しました。"
    redirect_to root_path
  end
  
  def rank_index
    @users = User.where(is_deleted: false).sort { |a, b| b.read_judgements.where(can_read: true).count + b.update_count <=> a.read_judgements.where(can_read: true).count + a.update_count}
  end
    
  
  private
  
  def user_params
    params.require(:user).permit(:nick_name, :email, :profile_image)
  end
end
