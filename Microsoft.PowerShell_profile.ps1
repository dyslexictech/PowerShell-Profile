Import-Module -Name posh-git
Import-Module PSReadLine

Set-Alias l Get-ChildItemColor -option AllScope -Force
Set-Alias ls Get-ChildItemColor -option AllScope -Force
Set-Alias dir Get-ChildItemColor -option AllScope -Force

Set-PSReadLineOption -HistoryNoDuplicates
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -HistorySaveStyle SaveIncrementally
Set-PSReadLineOption -MaximumHistoryCount 4000

# history substring search
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

# Tab completion
Set-PSReadlineKeyHandler -Chord 'Shift+Tab' -Function Complete
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

function cddash {
    if ($args[0] -eq '-') {
        $pwd = $OLDPWD;
    } else {
        $pwd = $args[0];
    }
    $tmp = pwd;

    if ($pwd) {
        Set-Location $pwd;
    }
    Set-Variable -Name OLDPWD -Value $tmp -Scope global;
}

Set-Alias -Name cd -value cddash -Option AllScope

$env:path = [Runtime.InteropServices.RuntimeEnvironment]::GetRuntimeDirectory()
[AppDomain]::CurrentDomain.GetAssemblies() | % {
  if (! $_.location) {continue}
  $Name = Split-Path $_.location -leaf
  Write-Host -ForegroundColor Yellow "NGENing : $Name"
  ngen install $_.location | % {"`t$_"}
}
