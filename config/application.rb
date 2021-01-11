require_relative "boot"

require "rails/all"

# if Rails.env.development? || Rails.env.test?
#   Warning[:deprecated] = false
# end

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ShogiWeb
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # https://qiita.com/suketa/items/09ebd4fbbd22fea9033d
    config.add_autoload_paths_to_load_path = false # $LOAD_PATH を使わず zeitwerk だけにすると速くなる

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.time_zone = "Tokyo"
    # config.eager_load_paths << Rails.root.join("extras")
    config.i18n.default_locale = :ja
    config.colorize_logging = false
    config.before_configuration do
      ::AppConfig = {}
      require Rails.root.join("config/app_config")
      config.app_config = AppConfig
    end

    if Rails.env.development? || Rails.env.test?
      config.action_mailer.default_url_options = {host: "localhost", port: 3000} # update だと nil.update になる
      # https://github.com/rails/rails/issues/32500
      # OGP画像がフルURLになるか確認するためだけにある
      Rails.application.routes.default_url_options.update(host: "0.0.0.0", port: 3000)
    end

    config.action_view.field_error_proc = proc { |html_tag, instance|
      if instance.kind_of?(ActionView::Helpers::Tags::Label)
        html_tag.html_safe
      else
        # method_name = instance.instance_variable_get(:@method_name)
        # errors = instance.object.errors[method_name]
        # "<div class=\"has-error\">#{html_tag}<span class=\"help-block\">#{errors.first}</span></div>".html_safe
        "<span class=\"has-error\">#{html_tag}</span>".html_safe
      end
    }
  end
end
