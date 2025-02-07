$ENV:Path += ";$ENV:SCOOP\apps\volta\current\appdata\bin;$ENV:SCOOP\apps\nodejs\current"
$ENV:XDG_CONFIG_HOME = "$ENV:SCOOP\apps"
$ENV:XDG_DATA_HOME = "$ENV:SCOOP\apps"

# $ENV:USERPROFILE = "D:\Users\(name)"

# $env:SCOOP = 'D:\Users\(name)\scoop'
# [Environment]::SetEnvironmentVariable('SCOOP', $env:SCOOP, 'User') # これを行うとすごく遅い

# function _Edit_Alacritty_Yml {vim $Env:APPDATA/alacritty/alacritty.yml}
# Set-Alias Edit-Alacritty-Yml _Edit_Alacritty_Yml

function _CC ($arg) { cat $arg | clip.exe }
Set-Alias cc _CC
Set-Alias vi nvim
Set-Alias vim nvim

# function Edit_Profile {vim $profile}
# Set-Alias Edit-Profile Edit_Profile

# function Reload_Profile {. $profile}
# Set-Alias Reload-Profile Reload_Profile

# function Open_Startup {explorer.exe "$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"}
# Set-Alias Open-Startup Open_Startup

# (& volta completions powershell) | Out-String | Invoke-Expression

# Fzf + Ctrl-r
Set-PSReadLineKeyHandler -Chord Ctrl+r -ScriptBlock {
  Get-Content (Get-PSReadLineOption).HistorySavePath > $ENV:USERPROFILE/tmp/ctrlr 
  $command = tac $ENV:USERPROFILE/tmp/ctrlr | awk '!a[$0]++' | fzf -e +s
  Remove-Item $ENV:USERPROFILE/tmp/ctrlr
  [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
  if (!$command) { return } 
  [Microsoft.PowerShell.PSConsoleReadLine]::Insert($command)
}

Set-PSReadlineKeyHandler -Key 'Ctrl+u' -Function BackwardDeleteLine
Set-PSReadlineKeyHandler -Key 'Ctrl+b' -Function BackwardChar
Set-PSReadlineKeyHandler -Key 'Ctrl+f' -Function ForwardChar
Set-PSReadlineKeyHandler -Key 'Ctrl+d' -Function DeleteChar
Set-PSReadlineKeyHandler -Key 'Ctrl+h' -Function BackwardDeleteChar
Set-PSReadlineKeyHandler -Key 'Ctrl+p' -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key 'Ctrl+n' -Function HistorySearchForward
Set-PSReadlineKeyHandler -Key 'Ctrl+a' -Function BeginningOfLine
Set-PSReadlineKeyHandler -Key 'Ctrl+e' -Function EndOfLine

cd D:/Users/(name)
# ~
