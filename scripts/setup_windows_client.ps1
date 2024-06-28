$url = “https://raw.githubusercontent.com/ansible/ansible-documentation/devel/examples/scripts/ConfigureRemotingForAnsible.ps1” 7

$file = “$env:temp\ConfigureRemotingForAnsible.ps1”

(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)

powershell.exe -ExecutionPolicy ByPass -File $file


###############################################################



# Install OpenSSH
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0

# make sure updates are activated before you can install
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0


# service angucken
Get-WindowsCapability -Online | Where-Object Name -like '*OpenSSH.Server*' | Select-Object Name, State


# Start and configure SSH service
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'

# Configure firewall
New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22


# Enable SSH agent
Get-Service ssh-agent | Set-Service -StartupType Automatic
Start-Service ssh-agent

# Create ansible user
$password = ConvertTo-SecureString "passworti" -AsPlainText -Force
New-LocalUser -Name "ansible" -Password $password -FullName "Ansible User" -Description "User for Ansible automation"
Add-LocalGroupMember -Group "Administrators" -Member "ansible"

# Prepare for SSH key
New-Item -Path "C:\Users\ansible\.ssh" -ItemType Directory -Force
icacls "C:\Users\ansible\.ssh" /inheritance:r
icacls "C:\Users\ansible\.ssh" /grant "ansible:(OI)(CI)F"

New-Item -Path "C:\Users\ansible\.ssh\authorized_keys" -ItemType File -Force
icacls "C:\Users\ansible\.ssh\authorized_keys" /inheritance:r
icacls "C:\Users\ansible\.ssh\authorized_keys" /grant "ansible:(OI)(CI)F"

Write-Host "Windows client has been set up for Ansible management."
Write-Host "The Ansible SSH key will be deployed from the master server."

# Output client IP for verification
$clientIP = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias Ethernet).IPAddress
if ($windowsClients -contains $clientIP) {
    Write-Host "This client ($clientIP) is correctly listed in the configuration."
} else {
    Write-Host "Warning: This client ($clientIP) is not listed in the configuration file."
}


