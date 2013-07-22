$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'usesguid/active_record_extensions'
require 'usesguid/uuid22'
require 'usesguid/uuid_mysql'
require 'usesguid/uuid_sqlserver'
require 'usesguid/uuidtools'

module Usesguid
  VERSION = '1.0.0'
end

ActiveRecord::Base.class_eval { include Usesguid::ActiveRecordExtensions } if defined?( ActiveRecord::Base )
