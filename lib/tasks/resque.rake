require 'resque/tasks'

task 'resque:setup' => :environment do
  ENV['INTERVAL'] = '0.1'
  ENV['QUEUE'] = 'synchronize_phone_contacts,synchronize_phone_calls,synchronize_phone_text_messages,synchronize_phone_calendar_events,destroy_source'
  
  Resque.before_fork = Proc.new { ActiveRecord::Base.establish_connection }
end
