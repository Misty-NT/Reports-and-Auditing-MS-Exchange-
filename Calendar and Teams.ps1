Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline

Import-Module MicrosoftTeams
Connect-MicrosoftTeams

# Check a mailbox calendar’s permissions

# one mailbox
Get-MailboxFolderPermission -Identity "user@domain.com:\Calendar" |
  Sort-Object -Property User -Unique

# include sub-calendars (if they exist)
Get-MailboxFolderStatistics -Identity user@domain.com -FolderScope Calendar |
  Where-Object {$_.FolderPath -like "*Calendar*"} |
  ForEach-Object {
    Get-MailboxFolderPermission -Identity ("user@domain.com:" + $_.FolderPath)
  }

# Check a Microsoft 365 Group (backing a Team) calendar’s permissions

$grp = "User@domain.com"

# calendar folder permissions on the group mailbox
Get-MailboxFolderPermission -Identity "$grp:\Calendar"

# See who should have access
Get-UnifiedGroup -Identity $grp | Format-List DisplayName,ExternalDirectoryObjectId
Get-UnifiedGroupLinks -Identity $grp -LinkType Owners
Get-UnifiedGroupLinks -Identity $grp -LinkType Members

$gid = (Get-UnifiedGroup -Identity $grp).ExternalDirectoryObjectId
Get-TeamUser -GroupId $gid | Sort-Object User


 # Channel-level membership
 Get-TeamChannel -GroupId $gid | Select-Object DisplayName, MembershipType, Id

$chan = (Get-TeamChannel -GroupId $gid | Where-Object {$_.DisplayName -eq "Private Ops"}).Id
Get-TeamChannelUser -GroupId $gid -ChannelId $chan



# All mailboxes’ default calendar sharing posture:
Get-ExoMailbox -RecipientTypeDetails UserMailbox -ResultSize Unlimited |
ForEach-Object {
  try {
    $perm = Get-MailboxFolderPermission -Identity "$($_.PrimarySmtpAddress):\Calendar" -ErrorAction Stop |
            Where-Object {$_.User -in @("Default","Anonymous")}
    [PSCustomObject]@{
      Mailbox   = $_.PrimarySmtpAddress
      Default   = ($perm | Where-Object {$_.User -eq "Default"}).AccessRights -join ","
      Anonymous = ($perm | Where-Object {$_.User -eq "Anonymous"}).AccessRights -join ","
    }
  } catch {
    [PSCustomObject]@{ Mailbox = $_.PrimarySmtpAddress; Default="(no access)"; Anonymous="(no access)" }
  }
} | Format-Table -Auto


# Single mailbox: 
Get-MailboxFolderPermission "user@domain.com:\Calendar" |
  Where-Object { $_.AccessRights -match "Editor|Owner|PublishingEditor|PublishingAuthor" }

# Group calendar 
$grp = "teamname@domain.com"
"=== Calendar Folder Permissions ==="
Get-MailboxFolderPermission "$grp:\Calendar"

# Group Owners 
Get-UnifiedGroupLinks -Identity $grp -LinkType Owners



