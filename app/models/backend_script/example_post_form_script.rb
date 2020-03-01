#
# フォームなし
#
# http://localhost:3000/admin/scripts/example_post_form_page
module BackendScript
  class ExamplePostFormScript < Base
    self.category = "スクリプト例"
    self.script_name = "POSTフォーム"
    self.post_method_use_p = true

    def form_parts
      {
        :label   => "値",
        :key     => :foo,
        :type    => :string,
        :default => params[:foo],
      }
    end

    def script_body
      params
    end
  end
end
