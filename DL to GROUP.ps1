# ensure new members get group mail in their inbox
Set-UnifiedGroup -Identity "company@mandmllp.com" -AutoSubscribeNewMembers

# (if needed) add/remove members/owners
Add-UnifiedGroupLinks -Identity "company@mandmllp.com" -LinkType Members -Links company@mandmllp.com
Add-UnifiedGroupLinks -Identity "company-old@mandmllp.com" -LinkType Owners -Links company-old@mandmllp.com



# 1) Create a new M365 Group
New-UnifiedGroup -DisplayName "Sales" -Alias "Sales" -EmailAddresses "sales@contoso.com"

# 2) Copy members from the old DL
$members = Get-DistributionGroupMember -Identity $dl | where {$_.RecipientType -like "*UserMailbox*" -or $_.RecipientType -like "*MailUser*"}
$members | foreach { Add-UnifiedGroupLinks -Identity "company@mandmllp.com" -LinkType Members -Links $_.PrimarySmtpAddress }
Add-UnifiedGroupLinks -Identity "company@mandmllp.com" -LinkType Owners -Links "users@mandmllp.com"
# 3) Teamify
$g = Get-UnifiedGroup -Identity "company@mandmllp.com"
New-Team -GroupId $g.ExternalDirectoryObjectId


# Find the old distribution group
Get-DistributionGroup -Identity "OldDL@contoso.com" | Format-List Name,PrimarySmtpAddress,HiddenFromAddressListsEnabled
# Hide the DL from the Global Address List (GAL)
Set-DistributionGroup -Identity "OldDL@contoso.com" -HiddenFromAddressListsEnabled $true

# Hide the group from Outlook/OWA as well For modern Microsoft 365 Groups (if the DL was already upgraded or recreated as a Group):

Set-UnifiedGroup -Identity "company@mandmllp.com" -HiddenFromAddressListsEnabled $false   # visible
Set-UnifiedGroup -Identity "Oldcompany@mandmllp.com" -HiddenFromAddressListsEnabled $true       # hidden

Verify changes

