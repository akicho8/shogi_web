module Api
  module Wkbk
    class ApplicationController < ::Api::ApplicationController
      include SortMod
      include PageMod

      class WkbkPermissionError < StandardError; end

      def sort_column_default
        :updated_at
      end

      # before_action :api_login_required
      def api_login_required
        unless current_user
          render json: { statusCode: 403, message: "ログインしてください" }, status: 403
        end
      end

      def owner_valid(record)
        unless record.owner_editable_p(current_user)
          raise WkbkPermissionError
        end
      end

      rescue_from "ActiveRecord::RecordNotFound" do |error|
        # 直接 404 を返すと $fetchState.error に入ってしまい error.vue には飛ばない
        # error.vue に飛ばす方法がわかれば、ここで 404 を返すようにする
        # とりあえず今あは 200 でエラーの情報を返している
        render json: { statusCode: 404, message: "または権限がありません" }, status: 404
      end

      rescue_from "WkbkPermissionError" do |error|
        render json: { statusCode: 403, message: "foo" }, status: 403
      end
    end
  end
end
