class SystemMailer < ApplicationMailer
  # SystemMailer.fixed_track.deliver_later
  # SystemMailer.fixed_track.deliver_now
  def fixed_track(params = {})
    mail(fixed_format(params.merge(subject: subject_decorate(params[:subject]))))
  end

  def simple_track(params = {})
    mail(params.merge(subject: subject_decorate(params[:subject])))
  end

  private

  def subject_prefix
    parts = []
    parts << "[#{AppConfig[:app_name]}]"
    unless Rails.env.production?
      parts << "[#{Rails.env}]"
    end
    parts.join + " "
  end

  def subject_decorate(subject)
    [subject_prefix, subject].join
  end

  # 表などが崩れないようにするための固定幅表示
  concerning :FixedFormatMethods do
    included do
      CSS_FONTS = %(Osaka-mono, "Osaka-等幅", "ＭＳ ゴシック", "Courier New", Consolas, monospace)
    end

    private

    def fixed_format(params)
      body = crln_to_br_for_gmail(params[:body].to_s)
      params.merge(content_type: "text/html", body: pre_tag(body))
    end

    def pre_tag(text)
      %(<pre style='white-space: pre; font-family: #{CSS_FONTS}'>#{text}</pre>)
    end

    # GMailで改行が2重になる対策
    def crln_to_br_for_gmail(text)
      text.gsub("\n", "<br>")
    end
  end
end
