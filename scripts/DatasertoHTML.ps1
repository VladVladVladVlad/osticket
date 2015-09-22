$a = $DataSet.Tables[0] | ConvertTo-Html
$b = $null
For ($i = 0; $i -lt $a.Length; $i++)
{
    [string]$b = [string]$b + $a.Item($i).tostring()
}

$b = $b -replace ("<th>RowError</th><th>RowState</th><th>Table</th><th>ItemArray</th><th>HasErrors</th></tr>", "")
$b = $b -replace ("<td></td><td>Unchanged</td><td>data</td><td>System.Object\[\]</td><td>False</td></tr>", "")
$b = $b -replace ("<head>","<head><style>table,th,td{border: 1px solid black;}</style>")
$b = $b -replace ('<th>Name</th>','<th aligh="left">Name</th>')
$b = $b -replace ('<th>Open</th>','<th aligh="left">Open</th>')