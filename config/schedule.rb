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

## rakuten_web_serviceのための定期実行
# config/schedule.rb
# Rails.rootを使用するために必要
require File.expand_path(File.dirname(__FILE__) + "/environment")
# cronを実行する環境変数
rails_env = ENV['RAILS_ENV'] || :development
# cronを実行する環境変数をセット
set :environment, rails_env
# cronのログの吐き出し場所
set :output, "#{Rails.root}/log/cron.log"

every 6.hour do
  rake "rakuten_book:insert", :environment_variable => "RAILS_ENV", :environment => "development"
end
# デブロイの時に、.envファイルにRAILS_ENV = productionを追加しておくと良い。


## update_limitのための定期実行
# 現状動かず。
require 'active_support/core_ext/time'

def jst(time)
  Time.zone = 'Asia/Tokyo'
  Time.zone.parse(time).localtime($system_utc_offset)
end

every 1.day, at: jst('4:00 am') do
  runner 'update_limit:reset'
end