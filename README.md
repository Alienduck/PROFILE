# CONFIG

## How it works

Windows have profiles config for your terminal, you can add custom commands and scripts. \
Create a `.config` folder at your user folder, then add another folder named `fastfetch` so you can put in there `ascii.txt`, `config.jsonc` and `old-logo-ascii.txt`, then just create a profile with this command:
```powershell
if (!(Test-Path -Path $PROFILE)) { New-Item -ItemType File - Path $PROFILE -Force }
```

and open with `notepad` or `code` or `nvim` or the text editor/IDE of your choice, then copy the content of my PROFILE file in yours.

Then you can enjoy it !
