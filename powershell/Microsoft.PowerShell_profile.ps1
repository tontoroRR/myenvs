# rbenv for Windows
$env:RBENV_ROOT = "C:\Ruby-on-Windows"

# Not easy to download on Github?
# Use a custom mirror!
# $env:RBENV_USE_MIRROR = "https://abc.com/abc-<version>"
& "$env:RBENV_ROOT\rbenv\bin\rbenv.ps1" init

# add jre8 env
$env:JAVA_HOME = $scoop_path + "\apps\temurin-lts-jdk\current"
$env:path = $env:path + $env:JAVA_HOME + "\bin;"

# VirtualBox
$env:path = $env:path + "C:\Program Files\Oracle\VirtualBox;"
# add OBS Studio
# $env:path = $env:path + $scoop_path + "\apps\obs-studio\current\bin\64bit;"

function permission_key($key_path) {
  New-Variable -Name Key -Value "$key_path"
  Icacls $Key /c /t /Inheritance:d
  Icacls $Key /c /t /Grant ${env:UserName}:F

  TakeOwn /F $Key
  Icacls $Key /c /t /Grant:r ${env:UserName}:F
  Icacls $Key /c /t /Remove:g Administrator "Authenticated Users" BUILTIN\Administrators BUILTIN Everyone System Users
  Icacls $Key
  Remove-Variable -Name Key
}

function sshv($vmname) {
  New-Variable -Name vmpath -Value (VBoxManage.exe showvminfo $vmname | rg "Name: 'vagrant'" | sd ".*path: '\\\\\?\\(.*)' .*" '$1')
  New-Variable -Name ip -Value (VBoxManage.exe showvminfo $vmname | rg 'ssh' | sd ".*host ip = ([\d\.]*),.*" '$1')
  New-Variable -Name port -Value (VBoxManage.exe showvminfo $vmname | rg 'ssh' | sd ".*host port = ([\d]*),.*" '$1')
  New-Variable -Name keypath -Value ".vagrant\machines\default\virtualbox\private_key"
  New-variable -Name user -Value 'vagrant'

  echo "ssh $user@$ip -p $port -i $vmpath\$keypath"
  ssh $user@$ip -p $port -i $vmpath\$keypath

  Remove-Variable -Name vmpath
  Remove-Variable -Name keypath
  Remove-Variable -Name ip
  Remove-Variable -Name port
  Remove-Variable -Name user
}

# Set-Alias -Name sshv -Value sshv
# Set-Alias -Name np -Value (nvim.exe $profile)

function gcd() {
  z $(ghq list --full-path | fzf)
}

function ge() {
  explorer $(ghq list --full-path | fzf)
}

# starship
$env:STARSHIP_CONFIG=$env:USERPROFILE + "\.config\starship\config.toml"
Invoke-Expression (&starship init powershell)

Import-Module posh-git

# Key Shortcut
Set-PSReadLineKeyHandler -Chord Ctrl+f -Function ForwardChar

# For zoxide v0.8.0+
# zoxide configuration should be last
# Invoke-Expression (& {
#     $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
#     (zoxide init --hook $hook powershell | Out-String)
# })
# for latest zoxide v0.9.4
Invoke-Expression (& { (zoxide init powershell | Out-String) })
