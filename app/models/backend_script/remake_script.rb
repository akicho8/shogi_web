# http://localhost:3000/admin/script/remake
module BackendScript
  class RemakeScript < ::BackendScript::Base
    include AtomicScript::PostRedirectMod

    self.category = "将棋ウォーズ"
    self.script_name = "将棋ウォーズ棋譜情報タグ再構築"

    def form_parts
      {
        :label   => "ウォーズID",
        :key     => :swars_id,
        :type    => :string,
        :default => params[:swars_id],
      }
    end

    def script_body
      if params[:swars_id]
        Swars::User.find_by(key: params[:swars_id]).battles.each(&:remake)
        "OK"
      end
    end
  end
end
