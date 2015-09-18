#connecting to datanase and executing query

$MySQLAdminUserName = 'root'
$MySQLAdminPassword = 'Cloudberry123'
$MySQLDatabase = 'osticket'
$MySQLHost = 'localhost'
$ConnectionString = "server=" + $MySQLHost + ";port=3306;uid=" + $MySQLAdminUserName + ";pwd=" + $MySQLAdminPassword + ";database="+$MySQLDatabase
$Query = 
"select osticket.ost_staff.username, count(*) 
from osticket.ost_staff
inner join osticket.ost_ticket 
on osticket.ost_staff.staff_id = osticket.ost_ticket.staff_id 
and osticket.ost_ticket.status like 'open' group by osticket.ost_staff.staff_id;"


Try {
  [void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")
  $Connection = New-Object MySql.Data.MySqlClient.MySqlConnection
  $Connection.ConnectionString = $ConnectionString
  $Connection.Open()
  
  $Command = New-Object MySql.Data.MySqlClient.MySqlCommand($Query, $Connection)
  $DataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($Command)
  $DataSet = New-Object System.Data.DataSet
  $RecordCount = $dataAdapter.Fill($dataSet, "data")
  $DataSet.Tables[0]
  }

  

Catch {
  Write-Host "ERROR : Unable to run query : $query `n$Error[0]"
 }

Finally {
  $Connection.Close()
  }

  $DataSet.Tables[0] | ConvertTo-HTML

  