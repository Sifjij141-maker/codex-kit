# Run from the task folder (Windows, for practice at home):
#   powershell -ExecutionPolicy Bypass -File $HOME\codex-kit\install.ps1
$Kit = Split-Path -Parent $MyInvocation.MyCommand.Path
$CodexHome = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $HOME ".codex" }
$Dest = Join-Path $CodexHome "skills"
New-Item -ItemType Directory -Force -Path $Dest | Out-Null
Copy-Item -Recurse -Force (Join-Path $Kit "skills\*") $Dest

$Tmp = Join-Path $env:TEMP ("superpowers-" + [guid]::NewGuid().ToString("N"))
git clone -q --depth 1 https://github.com/obra/superpowers.git $Tmp
if ($LASTEXITCODE -eq 0) {
  foreach ($s in "verification-before-completion", "systematic-debugging") {
    Copy-Item -Recurse -Force (Join-Path $Tmp "skills\$s") $Dest
  }
  Remove-Item -Recurse -Force $Tmp
} else {
  Write-Output "Could not download obra/superpowers. Installed the kit skills only."
}

if (-not (Test-Path "AGENTS.md")) {
  Copy-Item (Join-Path $Kit "AGENTS.md") "AGENTS.md"
  Write-Output "Copied AGENTS.md into this folder."
}

Write-Output "Installed skills in ${Dest}:"
Get-ChildItem $Dest -Name
Write-Output "Restart Codex (/quit, then codex)."
