# Essential program on linux

## Atom editor

### Install the ppa and program through terminal

```bash
sudo add-apt-repository ppa:webupd8team/atom
sudo apt update; sudo apt install atom
```

### Install the essential plug-ins

+ [ctrl+,] browse the installer
+ add packages : language-markdown, markdown-pdf, markdown-preview-plus, markdown-writer, split-diff, conver-to-utf8
+ add theme : seti(UI theme), Atom material Dark(syntax theme)
+ if got options.phantomPath, should follow below:
+ npm install phantomjs-prebuilt
+ Add new key binding
  + [ctrl+,] -> [keybinding] -> [your keymap file] -> add following lines
    ```json
    'atom-text-editor':
        'alt-l': 'editor:split-selections-into-lines'
    ```
+ change font for markdown-pdf
  + add the following lines in ~/.atom/styless.less
  ```css
  // for default markdown fonts
  .markdown-preview {
      font-size: 11px;
  }

  .markdown-body table {
    font-size: 12px !important;
  }
  ```
  + Install nodejs pacakge for phantomJS
  ```bash
  sudo npm install -g html-pdf
  ```
+ Change font for tree view
+ add the following lines in ~/.atom/styless.less
  ```css
  html, body, .tree-view, .tab, .tab-bar, .tooltip {
  font-family: 'D2Coding';
  }

  .tab.active {
  font-family: 'D2Coding';
  }

  .status-bar {
  font-family: 'D2Coding';
  // font-weight: bold;
  }
  ```

## Macbuntu

### Install tweak on ubuntu

```bash
sudo apt-get install unity-tweak-tool
wget archive.getdeb.net/ubuntu/pool/apps/u/ubuntu-tweak/ubuntu-tweak_0.8.7-1~getdeb2~xenial_all.deb
sudo dpkg -i ~/Downloads/ubuntu-tweak_0.8.7-1~getdeb2~xenial_all.deb
sudo apt-get -f install
```

+ (on unity tweak tool)
  + [Workspace Settings] -> make **2 by 2**
  + [Hotcorners] -> add __*Show Workspaces*__ on right-upper corner -> add __*Window Spread*__ on right-upper corner

### Install theme and icons

```bash
sudo add-apt-repository ppa:noobslab/macbuntu
sudo apt-get update
sudo apt-get install macbuntu-os-icons-lts-v7
sudo apt-get install macbuntu-os-ithemes-lts-v7

(optional uninstall)
cd /usr/share/icons/mac-cursors && sudo ./uninstall-mac-cursors.sh
sudo apt-get remove macbuntu-os-icons-lts-v7 macbuntu-os-ithemes-lts-v7
```

### Install the slingscold launch

```bash
sudo add-apt-repository ppa:noobslab/macbuntu
sudo apt-get update
sudo apt-get install slingscold
```

+ make slingscold as default search engine
  + (on unity tweak tool) [Additional] -> [Show the launcher] -> Press 'backspace' for disable
  + (on system keyboard shortcut configure) [Keyboard] -> [Custom Shortcuts] -> [+] -> {'Name':'default engine', 'Command': slingscold} -> set __*Super key*__

### Install the Albert Spotlight

```bash
sudo add-apt-repository ppa:noobslab/macbuntu
sudo apt-get update
sudo apt-get install albert
ln -s /usr/share/applications/albert.desktop ~/.config/autostart
```

+ after that, hotky should be set

### Change desktop name

+ change

```bash
cd && wget -O Mac.po http://drive.noobslab.com/data/Mac/change-name-on-panel/mac.po
cd /usr/share/locale/en/LC_MESSAGES; sudo msgfmt -o unity.mo ~/Mac.po;rm ~/Mac.po;cd
```

+ unchange

```bash
cd && wget -O Ubuntu.po http://drive.noobslab.com/data/Mac/change-name-on-panel/ubuntu.po
cd /usr/share/locale/en/LC_MESSAGES; sudo msgfmt -o unity.mo ~/Ubuntu.po;rm ~/Mac.po;cd
```

## Chrome

+ Download debian package from web

```bash
sudo wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
```

+ install through dpkg and fix the dependencies through aptitude

```bash
sudo apt-get install gdebi
sudo gdebi google-chrome-stable_current_adm64.deb
sudo apt-get -f install
```

## Remmina 1.2

```bash
sudo add-apt-repository ppa:remmina-ppa-team/remmina-next
sudo apt-get update
sudo apt-get install remmina
```

## Gonme Connection Manager

```bash
wget kuthulu.com/gcm/gnome-connection-manager_1.1.0_all.deb
sudo gdebi ./gnome-connection-manager_1.1.0_all.deb
```

## Shutter

+ install from ubuntu repository

```bash
sudo apt-get install shutter
```

## Configuration

+ [Preferences] -> [Behavior] -> check *Start Sutter at login*, *Hide window on first launch*
+ (on system keyboard shortcut configure) [Keyboard] -> [Custom Shortcuts] -> [+] -> {'Name':'Window Capture', 'Command': shutter -w} -> set __*print screen*__
+ (on system keyboard shortcut configure) [Keyboard] -> [Custom Shortcuts] -> [+] -> {'Name':'Selection Capture', 'Command': shutter -s} -> set __*shift + print screen*__
+ (on system keyboard shortcut configure) [Keyboard] -> [Custom Shortcuts] -> [+] -> {'Name':'Last Capture', 'Command': shutter -r} -> set __*ctrl + print screen*__

## Wine (Wine Is Not a Emulator) Project

```bash
# If your system is 64 bit, enable 32 bit architecture (if you haven't already):
sudo dpkg --add-architecture i386

#Add the repository:
wget -nc https://dl.winehq.org/wine-builds/Release.key
sudo apt-key add Release.key
sudo apt-add-repository https://dl.winehq.org/wine-builds/ubuntu/
sudo apt-get update
sudo apt-get install --install-recommends winehq-stable

winefile  # GUI file browser
winecfg   # GUI Wine configuration

```bash

[Desktop Entry]
Encoding=UTF-8
Name=HeidiSQL
Exec=env LC_ALL="ko_KR.UTF-8" WINEPREFIX="/home/roki/.wine" wine C:\\\\Program\\ Files\\\\HeidiSQL\\\\heidisql.exe
Type=Application
StartupNotify=true
Path=/home/roki/.wine/dosdevices/c:/Program Files/HeidiSQL
Icon=9103_heidisql.0

```

## Oracle VirtualBox

+ Download the program from [website](https://www.virtualbox.org) and install

```bash

wget http://download.virtualbox.org/virtualbox/5.2.0/virtualbox-5.2_5.2.0-118431~Ubuntu~zesty_amd64.deb
wget http://download.virtualbox.org/virtualbox/5.2.0/Oracle_VM_VirtualBox_Extension_Pack-5.2.0-118431.vbox-extpack
sudo gdebi virtualbox-5.2_5.2.0-118431~Ubuntu~zesty_amd64.deb

```


+ configuration
  + Install the extension-pack in nautilus
  + Add your user to vboxuser group in __/etc/group__


## Citrix Receiver

+ Download the program from [website](https://www.citrix.com/downloads/citrix-receiver/linux/receiver-for-linux-latest.html)
```bash

wget -O icaclient_13.7.0.10276927_amd64.deb https://downloads.citrix.com/13680/icaclient_13.7.0.10276927_amd64.deb?__gda__=1509000818_715e0def1af95dba919fbb2d7ef83e6c
wget -O icaclientWeb_13.7.0.10276927_amd64.deb https://downloads.citrix.com/13684/icaclientWeb_13.7.0.10276927_amd64.deb?__gda__=1509000818_b338155692f42070edac0b69e2defda6

```

+ install through following commands

```bash

sudo dpkg --add-architecture i386
sudo gdebi icaclient_13.6.0.10243651_amd64.deb
sudo apt-get -f install

```

## Install the variety

```bash

sudo add-apt-repository ppa:peterlevi/ppa
sudo apt-get update
sudo apt-get install variety variety-slideshow

```


## Etc

```bash

sudo apt-get install easytag
sudo apt-get install filezilla
sudo apt-get install ssvnc        # SSH/VNC client
sudo apt-get install vlc          # media player
sudo apt-get install sshpass      # for ssh alias
sudo apt-get install ubuntu-restricted-extras   # CODEC for ubuntu
sudo apt-get install tlp tlp-rdw  # for your battery
sudo apt-get install alacarte     # Main-menu Editor
sudo apt-get install cairo-dock   # dock program on ubuntu 17.10 has bugs
sudo apt-get install solaar       # for unifying logitech receiver

```

## git configruation

```bash

git config --global user.name "John Doe"
git config --global user.email johndoe@example.com
git config --global core.editor vim
git config --global merge.tool vimdiff
git config --global http.postBuffer 1048576000  # set to 1GB
git config --global color.ui true
git config --global format.pretty oneline

```

## for server

```bash

alias ssh_was='sshpass -p "" ssh -p 10022 -o StrictHostKeyChecking=no root@14.63.222.117'
alias ssh_db='sshpass -p "" ssh -p 10023 -o StrictHostKeyChecking=no root@14.63.222.117'
alias ssh_cdh01='sshpass -p "" ssh -p 10024 -o StrictHostKeyChecking=no root@14.63.222.117'
alias ssh_cdh02='sshpass -p "" ssh -p 10025 -o StrictHostKeyChecking=no root@14.63.222.117'
alias ssh_cdh03='sshpass -p "" ssh -p 10026 -o StrictHostKeyChecking=no root@14.63.222.117'
alias ssh_cdh04='sshpass -p "" ssh -p 10027 -o StrictHostKeyChecking=no root@14.63.222.117'
alias ssh_fm_was='sshpass -p "" ssh -p 10022 -o StrictHostKeyChecking=no root@14.63.217.49'
alias ssh_fm_db='sshpass -p "" ssh -p 10023 -o StrictHostKeyChecking=no root@14.63.217.49'
alias ssh_fm_cdh01='sshpass -p "" ssh -p 10122 -o StrictHostKeyChecking=no root@14.63.217.49'
alias ssh_fm_cdh02='sshpass -p "" ssh -p 10123 -o StrictHostKeyChecking=no root@14.63.217.49'
alias ssh_fm_cdh03='sshpass -p "" ssh -p 10124 -o StrictHostKeyChecking=no root@14.63.217.49'
alias ssh_fm_cdh04='sshpass -p "" ssh -p 10125 -o StrictHostKeyChecking=no root@14.63.217.49'
alias ssh_pi3='sshpass -p "" ssh -p 22 -o StrictHostKeyChecking=no pi@192.168.247.245'
alias deep_com='sshpass -p "" ssh -p 22 -o StrictHostKeyChecking=no deepcom@203.238.222.45'

```