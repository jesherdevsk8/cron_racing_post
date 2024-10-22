# frozen_string_literal: true

require 'whenever'

# update crontab after change this file with command: whenever --update-crontab
APP_ROOT = File.expand_path('..', __dir__)

# set :output, "#{APP_ROOT}/tmp/cron.log"
env :TZ, 'America/Sao_Paulo'

# Rodar rotinas todos os dias às 22:30
# grep cron /var/log/syslog
# tail -f /var/log/syslog

every 1.day, at: '22:00' do
  command "cd #{APP_ROOT} && rm -f tmp/*.log"
end 

every 1.day, at: '22:30' do
  command "cd #{APP_ROOT} && bundle exec ruby bin/run_next_race.rb 2> tmp/run_next_race_cron.log"
end

every 1.day, at: '22:35' do
  command "cd #{APP_ROOT} && bundle exec ruby bin/run_last_race.rb 2>> tmp/run_last_race_cron.log"
end

