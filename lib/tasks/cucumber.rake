#-- copyright
# OpenProject is a project management system.
# Copyright (C) 2012-2015 the OpenProject Foundation (OPF)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See doc/COPYRIGHT.rdoc for more details.
#++

# IMPORTANT: This file is generated by cucumber-rails - edit at your own peril.
# It is recommended to regenerate this file in the future when you upgrade to a
# newer version of cucumber-rails. Consider adding your own code to a new file
# instead of editing this one. Cucumber will automatically load all features/**/*.rb
# files.

unless ARGV.any? { |a| a =~ /\Agems/ } # Don't load anything when running the gems:* tasks

  begin
    require 'shellwords'
    require 'cucumber'
    require 'cucumber/rake/task'

    namespace :cucumber do
      Cucumber::Rake::Task.new({ ok: ['db:test:prepare', 'assets:webpack'] }, 'Run features that should pass') do |t|
        t.fork = true # You may get faster startup if you set this to false
      end

      task :statsetup do
        require 'rails/code_statistics'
        ::STATS_DIRECTORIES << %w(Cucumber\ features features) if File.exist?('features')
        ::CodeStatistics::TEST_TYPES << 'Cucumber features' if File.exist?('features')
      end

      def get_plugin_features(prefix = nil)
        features = []
        Rails.application.config.plugins_to_test_paths.each do |dir|
          feature_dir = Shellwords.escape(File.join(dir, 'features'))
          if File.directory?(feature_dir)
            features << prefix unless prefix.nil?
            features << feature_dir
          end
        end
        features
      end

      def define_cucumber_task(name, description, arguments = [])
        desc description
        task name, arguments => ['db:test:prepare', 'assets:webpack'] do |_t, args|
          if name == :custom
            if not args[:features]
              raise 'Please provide :features argument, e.g. rake cucumber:custom[features/my_feature.feature]'
            end
            features = args[:features].split(/\s+/)
          else
            features = get_plugin_features

            if name == :plugins
              # in case we want to run cucumber plugins and there are none
              # we exit with positive message
              if features.empty?
                puts
                puts '##### There are no cucumber features for OpenProject plugins to be run.'
                puts
                exit(0)
              end
            end

            if name == :all
              features += [File.join(Rails.root, 'features')]
            end
          end

          Cucumber::Rake::Task.new({ cucumber_run: ['db:test:prepare', 'assets:webpack'] }, 'Run features that should pass') do |t|
            opts = (ENV['CUCUMBER_OPTS'] ? ENV['CUCUMBER_OPTS'].split(/\s+/) : [])
            ENV.delete('CUCUMBER_OPTS')
            opts += args[:options].split(/\s+/) if args[:options]

            # load feature support files from Rails root
            support_files = ['-r', Shellwords.escape(File.join(Rails.root, 'features'))]
            support_files += get_plugin_features(prefix = '-r')

            t.cucumber_opts = opts + support_files + features

            # If we are not in the test environment, the test gems are not loaded
            # by Bundler.require in application.rb, so we need to fork.
            t.fork = Rails.env != 'test'
          end
          Rake::Task['cucumber_run'].invoke
        end
      end

      define_cucumber_task(:plugins, 'Run plugin features', [:options])
      define_cucumber_task(:all, 'Run core and plugin features', [:options])
      define_cucumber_task(:custom, 'Run features selected via features argument', [:features])
    end

    desc 'Alias for cucumber:ok'
    task cucumber: 'cucumber:ok'

    task default: :cucumber

    # In case we don't have ActiveRecord, append a no-op task that we can depend upon.
    task 'db:test:prepare' do
    end

    task stats: 'cucumber:statsetup'
  rescue LoadError
    desc 'cucumber rake task not available (cucumber not installed)'
    task :cucumber do
      abort 'Cucumber rake task is not available. Be sure to install cucumber as a gem or plugin'
    end
  end

end
