class UUID

  def self.sqlserver_create(connection=ActiveRecord::Base.connection)
    raise "UUID.sql_server_create only works with SQL Server" unless connection.adapter_name.downcase =~ /sqlserver/
    parse connection.newid_function
  end

end
