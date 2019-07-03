Installing Ubuntu server 16.04
==============================

## Get ubuntu server 16.04
+ Download the image from website
+ (In terminal)
  ```bash
  wget releases.ubuntu.com/16.04.2/ubuntu-16.04.2-server-amd64.iso
  ```
+ Use **rufus** program make iso to usb disk


## Install gnome 3.20
+ (In terminal)
  ```bash
  sudo add-apt-repository ppa:gnome3-team/gnome3-staging
  sudo add-apt-repository ppa:gnome3-team/gnome3
  ```
+ Refresh your software sources:
  ```bash
  sudo apt update
  ```
+ Install GNOME (if you don’t already use it):
  ```bash
  sudo apt install gnome gnome-shell gnome-session
  ```


## Install Nvidia driver without errors
+ Disable nouevnu kernel driver
  ```bash
  sudo vi /etc/modprobe.d/blacklist-nouveau.conf
  blacklist nouveau
  blacklist lbm-nouveau
  options nouveau modeset=0
  alias nouveau off
  alias lbm-nouveau off
  (wq!)
  echo "options nouveau modeset=0" | sudo tee /etc/modprobe.d/nouveau-kms.conf
  sudo update-initramfs -u
  ```
+ Update Grub
  ```bash
  sudo sed -is 's/GRUB_CMDLINE_LINUX_DEFAULT=\"/GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash nomodeset/g' /etc/default/grub
  sudo update-grub
  reboot
  ```
+ Install stable Nvidia driver
  ```bash
  sudo add-apt-repository ppa:graphics-drivers/ppa
  sudo apt-get update
  sudo apt-cache search nvidia
  sudo apt-get install nvidia-387 nvidia-prime
  reboot
  ```
  > it will fix the login loop and black screen on boot

+ Change nautilus configuration for convenience
  + Download the font file from [this link](https:/github.com/naver/d2codingfont "D2codingfont")
  ```bash
  wget https://github.com/naver/d2codingfont/releases/download/VER1.21/D2Coding-1.2.zip
  unzip D2Coding-1.2.zip -d fonts
  ```
  ![  ](images/font_install.png)
  > for explanation [What should use D2codingfont?](https://m.blog.naver.com/PostView.nhn?blogId=eominsuk55&logNo=220696227935&proxyReferer=https%3A%2F%2Fwww.google.co.kr%2F)
  + Install the fonts
  ```bash
  cd fonts
  sudo gnome-font-viewer D2Coding.ttc
  ```
  ![  ](images/font_view.png)
  > press install button on the upper-right corner
  + Configure as default font in terminal
    + nautilus -> Edit -> Profile Preferences -> general -> choose **D2Coding font, size 12**
    + nautilus -> Edit -> Profile Preferences -> general -> choose **Terminal size 140 by 40**
    + nautilus -> Edit -> Profile Preferences -> colors -> choose **Use transparent background**
+ Configure custom shorcut
  + (on system keyboard shortcut configure) [Keyboard] -> [Custom Shortcuts] -> [+] -> {'Name':'force stop current', 'Command': setxkbmap -option terminate:ctrl_alt_bksp} -> set __*ctrl+alt+bksp*__
  + (on system keyboard shortcut configure) [Keyboard] -> [Custom Shortcuts] -> [+] -> {'Name':'force stop', 'Command': gnome-system-monitor} -> set __*Super+Delete*__


## Change locale on ubuntu server
+ Check the locale and install language pack
    ```bash
    sudo localectl
    sudo apt-get -y install language-pack-ko-base language-pack-ko
    sudo localectl set-locale LANG=ko_KR.UTF-8 LANGUAGE="ko_KR:ko"
    sudo localectl
    ```
