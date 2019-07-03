Install sublimetext3 in ubuntu
==============================


## Install the software through the aptitute
+ Open terminal via Ctrl+Alt+T or by searching for “Terminal” from desktop app launcher. When it opens, run command to install the key:
  ```bash
  wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
  ```


+ Then add the apt repository via command:
  ```bash
  echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
  ```


+ Finally check updates and install sublime-text
  ```bash
  sudo apt-get update
  sudo apt-get install sublime-text
  ```

## Install package control
+ Copy the source code from below
+ for [sublimetext2](https://packagecontrol.io/installation#st2)
  ```
  import urllib2,os,hashlib; h = '6f4c264a24d933ce70df5dedcf1dcaee' + 'ebe013ee18cced0ef93d5f746d80ef60'; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); os.makedirs( ipp ) if not os.path.exists(ipp) else None; urllib2.install_opener( urllib2.build_opener( urllib2.ProxyHandler()) ); by = urllib2.urlopen( 'http://packagecontrol.io/' + pf.replace(' ', '%20')).read(); dh = hashlib.sha256(by).hexdigest(); open( os.path.join( ipp, pf), 'wb' ).write(by) if dh == h else None; print('Error validating download (got %s instead of %s), please try manual install' % (dh, h) if dh != h else 'Please restart Sublime Text to finish installation')
  ```
+ for [sublimetext3](https://packagecontrol.io/installation#st3)
  ```
  import urllib.request,os,hashlib; h = '6f4c264a24d933ce70df5dedcf1dcaee' + 'ebe013ee18cced0ef93d5f746d80ef60'; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); by = urllib.request.urlopen( 'http://packagecontrol.io/' + pf.replace(' ', '%20')).read(); dh = hashlib.sha256(by).hexdigest(); print('Error validating download (got %s instead of %s), please try manual install' % (dh, h)) if dh != h else open(os.path.join( ipp, pf), 'wb' ).write(by)
  ```
+ **ctrl + `** and add the code


## Install the essential package through package control
+ **ctrl + shift + p** and select 'Package Control : Install Package'
+ Install **emmet, text pastry, convertoutf8, sftp**
+ Change default font
  - **Preferences** -> **Settings** -> add the below lines
  ```
  {
  	"ignored_packages":
  	[
  		"Vintage"
  	],
  	"font_face": "D2Coding",
  	"font_size": 12
  }
  ```
