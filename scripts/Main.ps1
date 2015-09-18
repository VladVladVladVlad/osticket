﻿#connecting to datanase and executing query

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
  #$DataSet.Tables[0]
  }

  

Catch {
  Write-Host "ERROR : Unable to run query : $query `n$Error[0]"
 }

Finally {
  $Connection.Close()
  }

#converting dataset to HTML

$a = $DataSet.Tables[0] | ConvertTo-Html
$b = $null
For ($i = 0; $i -lt $a.Length; $i++)
{
    [string]$b = [string]$b + $a.Item($i).tostring()
}

$c = $b -replace ("<th>RowError</th><th>RowState</th><th>Table</th><th>ItemArray</th><th>HasErrors</th></tr>", "")
$d = $c -replace ("<td></td><td>Unchanged</td><td>data</td><td>System.Object\[\]</td><td>False</td></tr>", "")

#sending email

$secpasswd = ConvertTo-SecureString "!234igbyfn" -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential ("vlad.m@cloudberrylab.com", $secpasswd)
Send-MailMessage -to "vlad.m@cloudberrylab.com" -Subject "OsTicket daily stats" -Body $d -BodyAsHtml -SMTP "smtp.gmail.com" -From "vlad.m@cloudberrylab.com" -Credential $mycreds -UseSsl
