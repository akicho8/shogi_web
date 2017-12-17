# -*- coding: utf-8; compile-command: "cap production deploy:upload FILES=config/schedule.rb whenever:update_crontab crontab" -*-
# capp rails:cron_log

set :output, {standard: "log/#{@environment}_cron.log"}

job_type :command, "cd :path && :task :output"
job_type :runner,  "cd :path && bin/rails runner -e :environment ':task' :output"

every 1.hour do
  runner "p '  '"
end

every "*/15 * * * *" do
  runner [
    %(p [Time.current.to_s, 'begin', BattleUser.count, BattleRecord.count]),
    %(BattleRecord.import_batch(limit: 5, page_max: 3, sleep: 2, battle_grade_key_gteq: '初段')),
    %(p [Time.current.to_s, 'end__', BattleUser.count, BattleRecord.count]),
  ].join(";")
end
