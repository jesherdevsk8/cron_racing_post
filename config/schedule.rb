# frozen_string_literal: true

require 'whenever'

# update crontab after change this file with command: whenever --update-crontab
APP_ROOT = File.expand_path('..', __dir__)

# set :output, "#{APP_ROOT}/tmp/cron.log"
env :TZ, 'America/Sao_Paulo'
env :PATH, ENV['PATH']

# Rodar rotinas todos os dias às 22:30
# grep cron /var/log/syslog
# tail -f /var/log/syslog
# while :; do sleep 1; clear; grep 'cron' /var/log/syslog; done

every 1.day, at: '23:10' do
  command "cd #{APP_ROOT} && rm -f tmp/*.log"
end

every 1.day, at: '23:20' do
  command "cd #{APP_ROOT} && /usr/local/bin/ruby bin/run_next_race.rb 2> tmp/run_next_race_cron.log"
end

every 1.day, at: '23:25' do
  command "cd #{APP_ROOT} && /usr/local/bin/ruby bin/run_last_race.rb 2>> tmp/run_last_race_cron.log"
end
