# Active la completion Git
Import-Module posh-git -ErrorAction SilentlyContinue
# ======================
# Alias Git
# ======================
function ga { git add $args }
function commit {
    param([string]$Message)
    git commit -m $Message
}
function push {
        param([string]$Message)
        git push $Message
}
function gacp {
    param([string]$msg)
    git add .
    git commit -m $msg
    git push
}
function push-force {
    git push origin main --force-with-lease
}

# ======================
# Alias navigation / fichiers
# ======================
Set-Alias la "Get-ChildItem -Force"             # ls -a
Set-Alias ll "Get-ChildItem -Force -Detailed"   # ls -l

# ======================
# Alias Reseau / Systeme
# ======================
function open-ports { netstat -ano | findstr LISTENING } # Liste les ports
function ip { Get-NetIPAddress | Where-Object { $_.AddressFamily -eq "IPv4" -and $_.PrefixOrigin -eq "Dhcp" } }
function processes { Get-Process | Sort-Object CPU -Descending | Select-Object -First 20 } # Liste les processus
function start-php-website { php -S localhost:8000 } # Se mettre Ã  la racine de l'index.php
function admin { Set-ExecutionPolicy Bypass -Scope Process } # Merci choco

# ======================
# Alias utilitaires
# ======================
function grep { Select-String $args }   # Simule grep
function reload-profile { . $PROFILE }  # Recharge le profil sans reload
function edit-profile { notepad $PROFILE } # Edit ce fichier
function reload-sourcemap { rojo sourcemap .\default.project.json -o .\sourcemap.json } # Recharge le sourcemap.json (ROBLOX)
function delete-folder { Remove-Item -Recurse -Force } # rm -Rf
function Kill-AllProcessesByName {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ProcessName
    )

    $processes = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue
    if ($processes) {
        $processes | ForEach-Object {
            try {
                Stop-Process -Id $_.Id -Force
                Write-Host "Killed PID $($_.Id) ($($_.ProcessName))" -ForegroundColor Green
            } catch {
                Write-Host "Failed to kill PID $($_.Id): $_" -ForegroundColor Red
            }
        }
    } else {
        Write-Host "No process found with name '$ProcessName'" -ForegroundColor Yellow
    }
}
function start-server {
        pnpm tsc
        node dist\server.ts
}
function unzip {
        param (
                [Parameter(Mandatory=$true)]
                [string]$FileLocation,
                [Parameter(Mandatory=$true)]
                [string]$DestinationName
        )

        Expand-Archive -Path $FileLocation -DestinationPath $DestinationName
}
function open-vault {
        param(
        [string]$Vault,
        [string]$File
        )

        $encVault = [uri]::EscapeDataString($Vault)
        $url = "obsidian://open?vault=$encVault"
        if ($File) {
                $encFile = [uri]::EscapeDataString($File)
                $url += "&file=$encFile"
        }
        Start-Process $url
}

# ======================
# Troll
# ======================
function casse-couilles { cargo clippy }
function garco {
    param (
        [int]$Duration = 5
    )
    $frames = @("|", "/", "-", "\\")
    $endTime = (Get-Date).AddSeconds($Duration)
    $i = 0
    while ((Get-Date) -lt $endTime) {
        Write-Host -NoNewline "`rLoading $($frames[$i])"
        Start-Sleep -Milliseconds 200
        $i = ($i + 1) % $frames.Count
    }
    Write-Host "`rDone!        "
    Write-Host "Clippy lauchned #(remove for release)"
    Start-Sleep -Milliseconds 250
    cargo clippy
}
function tg { echo "TG Teddy" }

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# ======================
# PowerShell config
# ======================
# Minimal profile: UTFâ€‘8 + Oh My Posh (if installed) + Fastfetch with explicit config path
try {
    [Console]::InputEncoding  = [System.Text.Encoding]::UTF8
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    $OutputEncoding = [System.Text.UTF8Encoding]::new($false)
    chcp 65001 > $null
} catch {}

Clear-Host

# Force Fastfetch to use YOUR config every time (bypass path confusion)
if (Get-Command fastfetch -ErrorAction SilentlyContinue) {
    fastfetch -c "$env:USERPROFILE\.config\fastfetch\config.jsonc"
}
