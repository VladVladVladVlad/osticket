$a = $DataSet.Tables[0] | ConvertTo-Html
$b = $null
For ($i = 0; $i -lt $a.Length; $i++)
{
    [string]$b = [string]$b + $a.Item($i).tostring()
}

$c = $b -replace ("<th>RowError</th><th>RowState</th><th>Table</th><th>ItemArray</th><th>HasErrors</th></tr>", "")
$d = $c -replace ("<td></td><td>Unchanged</td><td>data</td><td>System.Object\[\]</td><td>False</td></tr>", "")