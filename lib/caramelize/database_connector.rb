require 'mysql2'

module Caramelize
  module DatabaseConnector
  
    def database
      socket = ["/tmp/mysqld.sock", 
      "/tmp/mysql.sock", 
      "/var/run/mysqld/mysqld.sock",
      "/opt/local/var/run/mysql5/mysqld.sock",
      "/var/lib/mysql/mysql.sock"].detect{|socket| File.exist?(socket)  }
      @options[:socket] = socket
      @client = Mysql2::Client.new(@options) unless @client
      @client
      
    end
    
  end
  
end
