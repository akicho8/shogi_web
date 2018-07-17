module Colosseum
  class SessionsController < ApplicationController
    def destroy
      if current_user
        current_user_logout
        notice = "ログアウトしました。"
      else
        notice = "すでにログアウトしています。"
      end
      redirect_to :root, tost_notice: notice
    end
  end
end
