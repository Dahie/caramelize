# frozen_string_literal: true

require 'mysql2'

module Caramelize
  module DatabaseConnector
    def database
      @options[:socket] = ['/tmp/mysqld.sock',
                           '/tmp/mysql.sock',
                           '/var/run/mysqld/mysqld.sock',
                           '/opt/local/var/run/mysql5/mysqld.sock',
                           '/var/lib/mysql/mysql.sock'].detect { |socket| File.exist?(socket) }
      @client ||= Mysql2::Client.new(@options)
      @client
    end
  end
end
