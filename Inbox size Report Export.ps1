$mailboxes = @(
  "Email@email.com",
"Email@email.com",
"Email@email.com",
"Email@email.com",

)

# Create an empty array to collect results
$results = @()

foreach ($email in $mailboxes) {
    $stats = Get-MailboxStatistics -Identity $email | Select-Object DisplayName, TotalItemSize

    # Add the result to the array
    $results += $stats
}

# Export to CSV
$results | Export-Csv -Path "C:\NT\SHAREDMB1 SIZE REPORT.csv" -NoTypeInformation -Encoding UTF8
