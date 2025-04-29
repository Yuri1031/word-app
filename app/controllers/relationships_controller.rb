class RelationshipsController < ApplicationController
  def create 
    friend = User.find_by(email: params[:friend_email])
  
    if friend.nil?
      flash[:alert] = "対象ユーザーが見つかりませんでした"
      return render turbo_stream: turbo_stream.replace("search_result", partial: "relationships/search_result", locals: { searched_user: nil })
    end
  
    if current_user.matchers?(friend)
      flash.now[:notice] = "すでに友達です"
     elsif current_user.following?(friend)
      flash.now[:notice] = "すでに申請済みです"
     else
      current_user.follow(friend)
      flash.now[:success] = "友達申請を送りました"
    end
    @searched_user = friend
    @waiting_users = current_user.followings.reject { |u| current_user.matchers.include?(u) }
    @incoming_requests = current_user.followers.reject { |u| current_user.following?(u) }
    @matchers = current_user.matchers

    render turbo_stream: [
      turbo_stream.replace("search_result", partial: "relationships/search_result", locals: { searched_user: @searched_user }),
      turbo_stream.replace("waiting_list", partial: "relationships/waiting_list", locals: { users: @waiting_users }),
      turbo_stream.replace("friend_alert", partial: "relationships/friend_alert", locals: { count: @incoming_requests.count }),
      turbo_stream.replace("friend_list", partial: "relationships/friend_list", locals: { matchers: @matchers }),
      turbo_stream.replace("friend_count", partial: "relationships/friend_count", locals: { count: current_user.matchers.count })
    ]
  end

  def destroy
    other_user = User.find(params[:id])
    
    if current_user.following?(other_user)
      current_user.unfollow(other_user)
    end

    if other_user.following?(current_user)
      other_user.unfollow(current_user)
    end

    @waiting_users = current_user.followings.reject { |u| current_user.matchers.include?(u) }
    @matchers = current_user.matchers
    @incoming_requests = current_user.followers.reject { |u| current_user.following?(u) }
  
    render turbo_stream: [
      turbo_stream.replace("waiting_list", partial: "relationships/waiting_list", locals: { users: @waiting_users }),
      turbo_stream.replace("friend_alert", partial: "relationships/friend_alert", locals: { count: @incoming_requests.count }),
      turbo_stream.replace("friend_list", partial: "relationships/friend_list", locals: { matchers: @matchers }),
      turbo_stream.replace("friend_count", partial: "relationships/friend_count", locals: { count: current_user.matchers.count })
      
    ]

  end

  def search
    @searched_user = User.find_by(email: params[:email])
    if @searched_user.nil?
      render turbo_stream: turbo_stream.replace("search_result", partial: "relationships/search_result", locals: { searched_user: nil })
    else
      render turbo_stream: turbo_stream.replace("search_result", partial: "relationships/search_result", locals: { searched_user: @searched_user })
    end
  end
end
