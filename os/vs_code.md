# Install the MS Visual Studio Code in ubuntu

## Install the vscode

+ Open terminal and run command to download Microsoft GPG key:

```bash
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
```

+ Add the vscode repository to your system by running command:

```bash
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
```

+ Open terminal and run command to install the vscode

```bash
sudo apt-get update
sudo apt-get install code
```

## Essential the configuration for vscode

### Install from expansions(ctrl+shift+x)

+ Setting Sync
  + share the vscode setting through github gist
  + shift+alt+U : upload, shift+alt+D : download
  ```bash
  # from github.com
  Settings > Personal Access Tokens > Developer settings > Personal access tokes > Select 'gits' > Generate New Token
  ```
  + upload the settings through command
+ dracula : vscode theme, vscode-icons : file icon theme
+ ESLint : for javascript
+ GIT : Git Extension Pack
+ view in browser
+ beautify code
+ docker
+ auto import
+ Markdown settings
  + Markdown PDF
  + Markdown Lint
  + Markdown TOC
  + Markdown Shortcuts
