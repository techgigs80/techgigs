# Install chocolatey on windows for package manager

## Chocolatey is windows-based package manager like apt-get in ubunt, yum in centos

+ Setup the system variable for default location
  + In system variable : add 'ChocolateyInstall' with the location where you want
  + (in powershell)

  ```powershell
  Get-ExecutionPolicy   # If it returns Restricted
  Set-ExecutionPolicy Bypass -Scope Process

  Set-Variable -Name "ChocolateyInstall" -Value (Read-Host -Prompt "Install location")
  New-Item $ChocolateyInstall -Type Directory -Force
  [Environment]::SetEnvironmentVariable("ChocolateyInstall", $ChocolateyInstall, "User")
  iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
  ```

+ How to use chocolatey Commands (choco + )
  + list - lists remote or local packages
  + search - searches remote or local packages (alias for list)
  + info - retrieves package information. Shorthand for choco search pkgname --exact --verbose
  + install - installs packages from various sources
  + pin - suppress upgrades for a package
  + outdated - retrieves packages that are outdated. Similar to upgrade all --noop
  + upgrade - upgrades packages from various sources
  + uninstall - uninstalls a package
  + pack - packages up a nuspec to a compiled nupkg
  + push - pushes a compiled nupkg
  + new - generates files necessary for a chocolatey package from a template
  + source - view and configure default sources
  + sources - view and configure default sources (alias for source)
  + config - Retrieve and configure config file settings
  + feature - view and configure choco features
  + features - view and configure choco features (alias for feature)
  + apikey - retrieves or saves an apikey for a particular source
  + setapikey - retrieves or saves an apikey for a particular source (alias for apikey)
  + unpackself - have chocolatey set itself up
  + version - [DEPRECATED] will be removed in v1 - use `choco outdated` or `cup <pkg|all> -whatif` instead
  + update - [DEPRECATED] RESERVED for future use (you are looking for upgrade, these are not the droids you are looking for)

+ Upgrade the chocolatey

```powershell
choco upgrade chocolatey
```