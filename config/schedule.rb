# frozen_string_literal: true

require 'whenever'

# update crontab after change this file with command: whenever --update-crontab
APP_ROOT = File.expand_path('..', __dir__)

# set :output, "#{APP_ROOT}/tmp/cron.log"
env :TZ, 'America/Sao_Paulo'

# Rodar rotinas todos os dias às 23:00
# grep cron /var/log/syslog
# tail -f /var/log/syslog
every 1.day, at: '23:00' do
  command "cd #{APP_ROOT}"
  command 'rm -f tmp/cron.log'
  command 'bundle exec ruby bin/run_next_race.rb 2> tmp/cron.log'
  command 'bundle exec ruby bin/run_last_race.rb 2>> tmp/cron.log'
end
