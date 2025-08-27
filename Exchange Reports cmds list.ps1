#Check for Inbox rules 
Get-InboxRule -Mailbox email@emaildomain.com

#Delete an inbox rule (rule name is required)
Remove-InboxRule -Mailbox user@domain.com -Identity ".."

#Checking the Properties of a User's Mailbox:
Get-Mailbox  email@domain.com | Format-List *

#Checking Forwarding Settings:
Get-Mailbox email@domain.com | Select-Object ForwardingSMTPAddress, DeliverToMailboxAndForward

#Checking Mailbox Permissions:
Get-MailboxPermission email@domain.com
#Checking Mailbox Auto-Reply Settings:
Get-MailboxAutoReplyConfiguration email@domain.com

#Check if User is Using a Litigation Hold or Retention Policy:
Get-Mailbox email@domain.com | Select-Object LitigationHoldEnabled, RetentionHoldEnabled, RetentionPolicy

#Checking for External Forwarding:
Get-Mailbox -ResultSize Unlimited | Where-Object {$_.ForwardingSmtpAddress -ne $null}
