#Created by Brad Voris 4/8/15 
#Powershell 4.0 
#Hides User mailbox 
 
#Get SA credentials 
$LiveCred = Get-Credential 
#Enter Powershell Session to Exchange server and authenticate 
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://<EMAILSERVERNAME>/PowerShell/ -Credential $LiveCred -Authentication Kerberos 
#import the session/module 
Import-PSSession $Session 
#Read input from user GUI 
#$uservar = read-host "What is the username that needs to be hidden in Exchange?"  
Add-Type -AssemblyName System.Windows.Forms 
Add-Type -AssemblyName System.Drawing 
 
$form = New-Object System.Windows.Forms.Form  
$form.Text = "Global Address List Hider" 
$form.Size = New-Object System.Drawing.Size(300,200)  
$form.StartPosition = "CenterScreen" 
 
$OKButton = New-Object System.Windows.Forms.Button 
$OKButton.Location = New-Object System.Drawing.Point(75,120) 
$OKButton.Size = New-Object System.Drawing.Size(75,23) 
$OKButton.Text = "OK" 
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK 
$form.AcceptButton = $OKButton 
$form.Controls.Add($OKButton) 
 
$CancelButton = New-Object System.Windows.Forms.Button 
$CancelButton.Location = New-Object System.Drawing.Point(150,120) 
$CancelButton.Size = New-Object System.Drawing.Size(75,23) 
$CancelButton.Text = "Cancel" 
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel 
$form.CancelButton = $CancelButton 
$form.Controls.Add($CancelButton) 
 
$label = New-Object System.Windows.Forms.Label 
$label.Location = New-Object System.Drawing.Point(10,20)  
$label.Size = New-Object System.Drawing.Size(280,30)  
$label.Text = "What is the username that needs to be hidden in Exchange:" 
$form.Controls.Add($label)  
 
$textBox = New-Object System.Windows.Forms.TextBox  
$textBox.Location = New-Object System.Drawing.Point(10,60)  
$textBox.Size = New-Object System.Drawing.Size(260,20)  
$form.Controls.Add($textBox)  
 
$form.Topmost = $True 
 
$form.Add_Shown({$textBox.Select()}) 
$result = $form.ShowDialog() 
 
if ($result -eq [System.Windows.Forms.DialogResult]::OK) 
{ 
    $uservar = $textBox.Text 
     
} 
#Set mailbox to hidden 
Set-Mailbox -identity enterprise\$uservar -HiddenFromAddressListsEnabled $true 
#close remote session 
Remove-PSSession $Session 
Exit-PSSession
