#connecting to datanase and executing query

$MySQLAdminUserName = 'root'
$MySQLAdminPassword = 'Cloudberry123'
$MySQLDatabase = 'osticket'
$MySQLHost = 'localhost'
$ConnectionString = "server=" + $MySQLHost + ";port=3306;uid=" + $MySQLAdminUserName + ";pwd=" + $MySQLAdminPassword + ";database="+$MySQLDatabase
$Query = 
"(
	select osticket.ost_staff.username as 'Name', count(*) as 'Open'
	from osticket.ost_staff inner join osticket.ost_ticket 
	on osticket.ost_staff.staff_id = osticket.ost_ticket.staff_id 
	and osticket.ost_ticket.status like 'open'
	and (
		osticket.ost_staff.username like 'AntonT' or osticket.ost_staff.username like 'Igor' 
		or osticket.ost_staff.username like 'Ildar.Sh'
		or osticket.ost_staff.username like 'Juli'
		or osticket.ost_staff.username like 'Pavel'
		or osticket.ost_staff.username like 'SergeyK'
		or osticket.ost_staff.username like 'Vladimir'
        or osticket.ost_staff.username like 'AntonZ'
	)
	group by osticket.ost_staff.staff_id
	#order by osticket.ost_staff.username asc
)
union all
(
	select '_Total', count(*)
	from osticket.ost_staff inner join osticket.ost_ticket 
	on osticket.ost_staff.staff_id = osticket.ost_ticket.staff_id 
	and osticket.ost_ticket.status like 'open'
	and (
		osticket.ost_staff.username like 'AntonT' or osticket.ost_staff.username like 'Igor' 
		or osticket.ost_staff.username like 'Ildar.Sh'
		or osticket.ost_staff.username like 'Juli'
		or osticket.ost_staff.username like 'Pavel'
		or osticket.ost_staff.username like 'SergeyK'
		or osticket.ost_staff.username like 'Vladimir'
        or osticket.ost_staff.username like 'AntonZ'
	)
)
order by 1;"


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

$b = $b -replace ("<th>RowError</th><th>RowState</th><th>Table</th><th>ItemArray</th><th>HasErrors</th></tr>", "")
$b = $b -replace ('<colgroup><col/><col/><col/><col/><col/><col/><col/></colgroup>','')

$b = $b -replace ("<td></td><td>Unchanged</td><td>data</td><td>System.Object\[\]</td><td>False</td></tr>", "")
$b = $b -replace ("<head>","<head><style>table,th,td{border: 1px solid black;} table{border-collapse:collapse;} table {width: 20%;}</style>")

$b = $b -replace ('<th>Name</th>','<th align="left">Name</th>')
$b = $b -replace ('<th>Open</th>','<th align="left">Open</th>')


#sending email

#generating string for a subject
$date = Get-Date -UFormat '%d %B %Y'
$subject = "osTicket Stats (" + $date.ToString() +")"

$pass = Read-Host "Password for DEV\vladimir.m"


$secpasswd = ConvertTo-SecureString $pass -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential ("vlad.m@cloudberrylab.com", $secpasswd)
Send-MailMessage -to "vlad.m@cloudberrylab.com" -Subject $subject -Body $b -BodyAsHtml -SMTP "smtp.gmail.com" -From "vlad.m@cloudberrylab.com" -Credential $mycreds -UseSsl

