# DNS Manager GUI for Windows 11
# v1.0 by ClaudeMods
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "DNS Manager"
$form.Size = New-Object System.Drawing.Size(550, 520)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.BackColor = [System.Drawing.Color]::FromArgb(240, 242, 245)

# Color scheme
$navyBlue = [System.Drawing.Color]::FromArgb(28, 40, 71)
$mediumBlue = [System.Drawing.Color]::FromArgb(44, 62, 110)
$white = [System.Drawing.Color]::White
$darkGrey = [System.Drawing.Color]::FromArgb(100, 100, 100)
$accentRed = [System.Drawing.Color]::FromArgb(220, 53, 69)

# DNS servers data
$dnsServers = [ordered]@{
    "Cloudflare DNS" = @{
        IPv4 = @("1.1.1.1", "1.0.0.1")
        IPv6 = @("2606:4700:4700::1111", "2606:4700:4700::1001")
    }
    "Google Public DNS" = @{
        IPv4 = @("8.8.8.8", "8.8.4.4")
        IPv6 = @("2001:4860:4860::8888", "2001:4860:4860::8844")
    }
    "OpenDNS" = @{
        IPv4 = @("208.67.222.222", "208.67.220.220")
        IPv6 = @("2620:119:35::35", "2620:119:53::53")
    }
    "Quad9 DNS" = @{
        IPv4 = @("9.9.9.11", "149.112.112.11")
        IPv6 = @("2620:fe::11", "2620:fe::fe:11")
    }
    "AdGuard DNS" = @{
        IPv4 = @("94.140.14.14", "94.140.15.15")
        IPv6 = @("2a10:50c0::ad1:ff", "2a10:50c0::ad2:ff")
    }
}

# Function to get current DNS using Get-DnsClientServerAddress
function Get-CurrentDNS {
    try {
        $adapter = Get-NetAdapter | Where-Object { $_.Status -eq "Up" } | Select-Object -First 1
        
        if (-not $adapter) {
            return @()
        }
        
        $dnsConfig = Get-DnsClientServerAddress -InterfaceIndex $adapter.InterfaceIndex -AddressFamily IPv4 -ErrorAction SilentlyContinue
        $dnsConfig6 = Get-DnsClientServerAddress -InterfaceIndex $adapter.InterfaceIndex -AddressFamily IPv6 -ErrorAction SilentlyContinue
        
        $dnsServers = @()
        
        if ($dnsConfig) {
            $dnsServers += $dnsConfig.ServerAddresses
        }
        
        if ($dnsConfig6) {
            $dnsServers += $dnsConfig6.ServerAddresses
        }
        
        return $dnsServers
    }
    catch {
        return @()
    }
}

# Function to check if DNS matches a provider
function Check-DNSMatch {
    $currentDNS = Get-CurrentDNS
    
    if ($currentDNS.Count -eq 0) {
        return @{
            Matched = $false
            Name = "No DNS servers configured"
            Addresses = ""
            IPv4Primary = "Not set"
            IPv4Secondary = "Not set" 
            IPv6Primary = "Not set"
            IPv6Secondary = "Not set"
        }
    }
    
    # Separate IPv4 and IPv6
    $ipv4 = @()
    $ipv6 = @()
    
    foreach ($dns in $currentDNS) {
        if ($dns -match ":") {
            $ipv6 += $dns
        } else {
            $ipv4 += $dns
        }
    }
    
    # Check against known providers by comparing sorted arrays
    foreach ($providerName in $dnsServers.Keys) {
        $provider = $dnsServers[$providerName]
        
        # Sort and compare current DNS with provider's IPv4 addresses
        $currentIPv4Sorted = $ipv4 | Sort-Object
        $providerIPv4Sorted = $provider.IPv4 | Sort-Object
        
        # Sort and compare current DNS with provider's IPv6 addresses
        $currentIPv6Sorted = $ipv6 | Sort-Object
        $providerIPv6Sorted = $provider.IPv6 | Sort-Object
        
        # Check if both IPv4 and IPv6 arrays match exactly (order-independent)
        $ipv4Match = ($currentIPv4Sorted.Count -eq $providerIPv4Sorted.Count) -and 
                     (Compare-Object $currentIPv4Sorted $providerIPv4Sorted -SyncWindow 0).Count -eq 0
        
        $ipv6Match = ($currentIPv6Sorted.Count -eq $providerIPv6Sorted.Count) -and 
                     (Compare-Object $currentIPv6Sorted $providerIPv6Sorted -SyncWindow 0).Count -eq 0
        
        if ($ipv4Match -and $ipv6Match) {
            return @{
                Matched = $true
                Name = $providerName
                Addresses = ($provider.IPv4 + $provider.IPv6) -join ", "
                IPv4Primary = if ($ipv4.Count -gt 0) { $ipv4[0] } else { "Not set" }
                IPv4Secondary = if ($ipv4.Count -gt 1) { $ipv4[1] } else { "Not set" }
                IPv6Primary = if ($ipv6.Count -gt 0) { $ipv6[0] } else { "Not set" }
                IPv6Secondary = if ($ipv6.Count -gt 1) { $ipv6[1] } else { "Not set" }
            }
        }
    }
    
    # No match found - don't show "Custom DNS Configuration"
    return @{
        Matched = $false
        Name = ""
        Addresses = ""
        IPv4Primary = if ($ipv4.Count -gt 0) { $ipv4[0] } else { "Not set" }
        IPv4Secondary = if ($ipv4.Count -gt 1) { $ipv4[1] } else { "Not set" }
        IPv6Primary = if ($ipv6.Count -gt 0) { $ipv6[0] } else { "Not set" }
        IPv6Secondary = if ($ipv6.Count -gt 1) { $ipv6[1] } else { "Not set" }
    }
}

# Function to apply DNS settings
function Set-DNS {
    param([string]$ProviderName)
    
    try {
        $adapter = Get-NetAdapter | Where-Object { $_.Status -eq "Up" } | Select-Object -First 1
        
        if (-not $adapter) {
            [System.Windows.Forms.MessageBox]::Show("No active network connection found.", "Error", "OK", "Error")
            return
        }
        
        $dnsData = $dnsServers[$ProviderName]
        
        if ($dnsData.IPv4.Count -gt 0) {
            Set-DnsClientServerAddress -InterfaceIndex $adapter.InterfaceIndex -ServerAddresses $dnsData.IPv4
        }
        
        if ($dnsData.IPv6.Count -gt 0) {
            Set-DnsClientServerAddress -InterfaceIndex $adapter.InterfaceIndex -ServerAddresses $dnsData.IPv6
        }
        
        [System.Windows.Forms.MessageBox]::Show("DNS changed to $ProviderName", "Success", "OK", "Information")
        Update-Display
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show("Error: $($_.Exception.Message)", "Error", "OK", "Error")
    }
}

# Function to reset DNS to DHCP
function Reset-DNS {
    try {
        $adapter = Get-NetAdapter | Where-Object { $_.Status -eq "Up" } | Select-Object -First 1
        
        if (-not $adapter) {
            [System.Windows.Forms.MessageBox]::Show("No active network connection found.", "Error", "OK", "Error")
            return
        }
        
        Set-DnsClientServerAddress -InterfaceIndex $adapter.InterfaceIndex -ResetServerAddresses
        
        [System.Windows.Forms.MessageBox]::Show("DNS reset to default (DHCP)", "Success", "OK", "Information")
        Update-Display
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show("Error: $($_.Exception.Message)", "Error", "OK", "Error")
    }
}

# Function to update the display
function Update-Display {
    $dnsInfo = Check-DNSMatch
    
    $providerNameLabel.Text = $dnsInfo.Name
    $currentIPv4Label.Text = "IPv4: $($dnsInfo.IPv4Primary), $($dnsInfo.IPv4Secondary)"
    $currentIPv6Label.Text = "IPv6: $($dnsInfo.IPv6Primary), $($dnsInfo.IPv6Secondary)"
    
    if ($dnsInfo.Matched) {
        $providerNameLabel.ForeColor = $navyBlue
    } else {
        $providerNameLabel.ForeColor = $darkGrey
    }
    
    $form.Refresh()
}

# Create Header Panel
$headerPanel = New-Object System.Windows.Forms.Panel
$headerPanel.Size = New-Object System.Drawing.Size(550, 80)
$headerPanel.Location = New-Object System.Drawing.Point(0, 0)
$headerPanel.BackColor = $navyBlue

$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "DNS Manager"
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
$titleLabel.ForeColor = $white
$titleLabel.Size = New-Object System.Drawing.Size(500, 35)
$titleLabel.Location = New-Object System.Drawing.Point(20, 12)

$subtitleLabel = New-Object System.Windows.Forms.Label
$subtitleLabel.Text = "Manage your DNS settings easily"
$subtitleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$subtitleLabel.ForeColor = [System.Drawing.Color]::FromArgb(180, 190, 210)
$subtitleLabel.Size = New-Object System.Drawing.Size(300, 20)
$subtitleLabel.Location = New-Object System.Drawing.Point(20, 48)

$headerPanel.Controls.Add($titleLabel)
$headerPanel.Controls.Add($subtitleLabel)

# Current DNS Provider Section
$currentProviderGroup = New-Object System.Windows.Forms.GroupBox
$currentProviderGroup.Text = "Current DNS Provider"
$currentProviderGroup.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$currentProviderGroup.ForeColor = $mediumBlue
$currentProviderGroup.Size = New-Object System.Drawing.Size(500, 150)
$currentProviderGroup.Location = New-Object System.Drawing.Point(20, 90)

$providerNameLabel = New-Object System.Windows.Forms.Label
$providerNameLabel.Text = "Detecting..."
$providerNameLabel.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$providerNameLabel.ForeColor = $darkGrey
$providerNameLabel.Size = New-Object System.Drawing.Size(460, 30)
$providerNameLabel.Location = New-Object System.Drawing.Point(15, 25)

$currentIPv4Label = New-Object System.Windows.Forms.Label
$currentIPv4Label.Text = "IPv4: Detecting..."
$currentIPv4Label.Font = New-Object System.Drawing.Font("Consolas", 9)
$currentIPv4Label.ForeColor = $darkGrey
$currentIPv4Label.Size = New-Object System.Drawing.Size(460, 20)
$currentIPv4Label.Location = New-Object System.Drawing.Point(15, 65)

$currentIPv6Label = New-Object System.Windows.Forms.Label
$currentIPv6Label.Text = "IPv6: Detecting..."
$currentIPv6Label.Font = New-Object System.Drawing.Font("Consolas", 9)
$currentIPv6Label.ForeColor = $darkGrey
$currentIPv6Label.Size = New-Object System.Drawing.Size(460, 20)
$currentIPv6Label.Location = New-Object System.Drawing.Point(15, 90)

$currentProviderGroup.Controls.Add($providerNameLabel)
$currentProviderGroup.Controls.Add($currentIPv4Label)
$currentProviderGroup.Controls.Add($currentIPv6Label)

# DNS Provider Selection Section
$selectionGroup = New-Object System.Windows.Forms.GroupBox
$selectionGroup.Text = "Select DNS Provider"
$selectionGroup.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$selectionGroup.ForeColor = $mediumBlue
$selectionGroup.Size = New-Object System.Drawing.Size(500, 130)
$selectionGroup.Location = New-Object System.Drawing.Point(20, 250)

$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$listBox.Size = New-Object System.Drawing.Size(465, 90)
$listBox.Location = New-Object System.Drawing.Point(15, 25)
$listBox.BackColor = $white
$listBox.BorderStyle = "FixedSingle"

foreach ($provider in $dnsServers.Keys) {
    [void]$listBox.Items.Add($provider)
}

$selectionGroup.Controls.Add($listBox)

# Buttons
$applyButton = New-Object System.Windows.Forms.Button
$applyButton.Text = "Apply Selected DNS"
$applyButton.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$applyButton.Size = New-Object System.Drawing.Size(120, 35)
$applyButton.Location = New-Object System.Drawing.Point(20, 395)
$applyButton.BackColor = $navyBlue
$applyButton.ForeColor = $white
$applyButton.FlatStyle = "Flat"
$applyButton.FlatAppearance.BorderSize = 0
$applyButton.Cursor = [System.Windows.Forms.Cursors]::Hand
$applyButton.Add_Click({
    if ($listBox.SelectedItem) {
        Set-DNS -ProviderName $listBox.SelectedItem
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please select a DNS provider", "Warning", "OK", "Warning")
    }
})

$resetButton = New-Object System.Windows.Forms.Button
$resetButton.Text = "Reset to Default"
$resetButton.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$resetButton.Size = New-Object System.Drawing.Size(120, 35)
$resetButton.Location = New-Object System.Drawing.Point(150, 395)
$resetButton.BackColor = $darkGrey
$resetButton.ForeColor = $white
$resetButton.FlatStyle = "Flat"
$resetButton.FlatAppearance.BorderSize = 0
$resetButton.Cursor = [System.Windows.Forms.Cursors]::Hand
$resetButton.Add_Click({ Reset-DNS })

$refreshButton = New-Object System.Windows.Forms.Button
$refreshButton.Text = "Refresh Status"
$refreshButton.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$refreshButton.Size = New-Object System.Drawing.Size(120, 35)
$refreshButton.Location = New-Object System.Drawing.Point(280, 395)
$refreshButton.BackColor = $mediumBlue
$refreshButton.ForeColor = $white
$refreshButton.FlatStyle = "Flat"
$refreshButton.FlatAppearance.BorderSize = 0
$refreshButton.Cursor = [System.Windows.Forms.Cursors]::Hand
$refreshButton.Add_Click({ Update-Display })

$exitButton = New-Object System.Windows.Forms.Button
$exitButton.Text = "Exit"
$exitButton.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$exitButton.Size = New-Object System.Drawing.Size(80, 35)
$exitButton.Location = New-Object System.Drawing.Point(420, 395)
$exitButton.BackColor = $accentRed
$exitButton.ForeColor = $white
$exitButton.FlatStyle = "Flat"
$exitButton.FlatAppearance.BorderSize = 0
$exitButton.Cursor = [System.Windows.Forms.Cursors]::Hand
$exitButton.Add_Click({ $form.Close() })

# Version Label
$versionLabel = New-Object System.Windows.Forms.Label
$versionLabel.Text = "v1.0 29-07-2026 by claudemods"
$versionLabel.Font = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Italic)
$versionLabel.ForeColor = $accentRed
$versionLabel.Size = New-Object System.Drawing.Size(200, 20)
$versionLabel.Location = New-Object System.Drawing.Point(310, 445)
$versionLabel.TextAlign = [System.Drawing.ContentAlignment]::BottomRight
$versionLabel.BackColor = [System.Drawing.Color]::Transparent

# Add all elements to form
$form.Controls.Add($headerPanel)
$form.Controls.Add($currentProviderGroup)
$form.Controls.Add($selectionGroup)
$form.Controls.Add($applyButton)
$form.Controls.Add($resetButton)
$form.Controls.Add($refreshButton)
$form.Controls.Add($exitButton)
$form.Controls.Add($versionLabel)

# Initialize display
Update-Display

# Show the form
$form.Add_Shown({ $form.Activate() })
$form.ShowDialog() | Out-Null