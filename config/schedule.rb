# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :output, "log/cron_log.log"

every 1.day, :at => '3:30 am' do
  runner "ShiftCreatorJob.add_to_queue"
  runner "ShiftPendingJob.add_to_queue"
  runner "DocRefreshNotificationJob.perform"
end

every :reboot do
	rake "ts:regenerate"
	rake "assets:precompile"
	command "cd /home/ubuntu/UberNurse/current && RAILS_ENV=production ./script/delayed_job start"
	command "cd /home/ubuntu/UberNurse/current && sudo docker-compose -f config/elk-docker-compose.yml up -d"
end

every 1.month, :at => "start of the month at 11pm"
	
end
