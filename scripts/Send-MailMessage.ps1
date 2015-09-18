$secpasswd = ConvertTo-SecureString "!234igbyfn" -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential ("vlad.m@cloudberrylab.com", $secpasswd)
Send-MailMessage -to "vlad.m@cloudberrylab.com" -Subject "Send-MailMessage Test" -Body $d -BodyAsHtml -SMTP "smtp.gmail.com" -From "vlad.m@cloudberrylab.com" -Credential $mycreds -UseSsl