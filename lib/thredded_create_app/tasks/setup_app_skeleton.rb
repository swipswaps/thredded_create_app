# frozen_string_literal: true
require 'thredded_create_app/tasks/base'
module ThreddedCreateApp
  module Tasks
    class SetupAppSkeleton < Base
      MATERIAL_700_COLORS = [
        '#D32F2F', # red
        '#C2185B', # pink
        '#7B1FA2', # purple
        '#512DA8', # deep purple
        '#303F9F', # indigo
        '#1976D2', # blue
        '#0288D1', # light blue
        '#0097A7', # cyan
        '#00796B', # teal
        '#F57C00', # orange
      ].freeze

      def summary
        'Setup basic app navigation and styles'
      end

      def before_bundle
        add_gem 'rails-timeago'
      end

      def after_bundle
        add_styles
        add_user_page
        add_home_page
        add_i18n
        add_app_layout
        git_commit 'Set up basic app navigation and styles'
      end

      def add_styles
        copy_template 'setup_app_skeleton/_variables.scss.erb',
                      'app/assets/stylesheets/_variables.scss'

        if File.file? 'app/assets/stylesheets/application.css'
          File.delete 'app/assets/stylesheets/application.css'
        end
        copy_template 'setup_app_skeleton/application.scss',
                      'app/assets/stylesheets/application.scss',
                      mode: 'a'
        copy 'setup_app_skeleton/_flash-messages.scss',
             'app/assets/stylesheets/_flash-messages.scss'
      end

      def add_i18n
        copy_template 'setup_app_skeleton/en.yml.erb',
                      'config/locales/en.yml'
      end

      def add_app_layout
        copy 'setup_app_skeleton/_header.html.erb',
             'app/views/shared/_header.html.erb'
        copy 'setup_app_skeleton/_flash_messages.html.erb',
             'app/views/shared/_flash_messages.html.erb'
        app_helper_src = File.read(
          File.join(File.dirname(__FILE__),
                    'setup_app_skeleton/application_helper_methods.rb')
        )
        inject_into_file 'app/helpers/application_helper.rb',
                         before:  /end\n\z/,
                         content: indent(2, app_helper_src)
        replace 'app/views/layouts/application.html.erb',
                %r{<title>.*?</title>},
                '<title><%= page_title %></title>'
        replace 'app/views/layouts/application.html.erb',
                %r{<body>.*?</body>}m,
                File.read(
                  File.join(File.dirname(__FILE__),
                            'setup_app_skeleton/application.body.html.erb')
                )
      end

      def add_user_page
        run_generator 'controller users show' \
                      ' --no-assets --no-helper --skip-routes'
        copy 'setup_app_skeleton/users_show.html.erb',
             'app/views/users/show.html.erb'
        replace 'app/controllers/users_controller.rb', 'def show', <<-'RUBY'
  def show
    @user = User.find(params[:id])
        RUBY
        add_route <<~'RUBY'
          resources :users, only: [:show]
        RUBY
      end

      def add_home_page
        run_generator 'controller home show' \
                      ' --no-assets --no-helper --skip-routes'
        add_route <<~'RUBY', append: true
          root to: 'home#show'
        RUBY
        copy 'setup_app_skeleton/home_show.html.erb',
             'app/views/home/show.html.erb'
      end

      def brand_primary
        @brand_primary ||= MATERIAL_700_COLORS.sample.downcase
      end
    end
  end
end
