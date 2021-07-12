# useful links

- [Ansible in RHEL](https://sysnet4admin.blogspot.kr/2017/06/ansible-rhel-72.html#.WXcGgYTyipo)
- [Ansible Definition](https://brunch.co.kr/@jiseon3169ubie/2)
- [Go Lang - Programming](http://golang.site/go/article/8-Go-%EB%B0%98%EB%B3%B5%EB%AC%B8)
- [Docker for beginner](https://subicura.com/2017/01/19/docker-guide-for-beginners-2.html)
- [python bible](https://docs.python.org/2/library/math.html)
- [Data Mining : Web-R v2.0 beta](http://web-r.org/)
- [Word Cloud](https://www.jasondavies.com/wordcloud/)
- [SVM with polynomial kernel visualization](https://youtu.be/3liCbRZPrZA)
- [bayesian example](http://j1w2k3.tistory.com/1009)

## configuration

### check GPU type

```bash
sudo lshw -C display
```

### nvidia gpu mode change

```bash
## 0 default
## 1 Exclusive Thread
## 2 Prohibited
## 3 Exclusive Process
nvidia-smi -i ${GPU_ID} -c ${MODE_ID}
nvidia-smi  --query | grep 'Compute Mode' ## check for the result

for i in {0..7}; do sudo nvidia-smi -i $i -c ${MODE_ID}; done
```

### environment-module

```bash
sudo apt-get install autoconf tcl tcl-dev tcl8.6
git clone https://github.com/cea-hpc/modules.git
cd modules
CPPFLAGS="-DUSE_INTERP_ERRORLINE" ./configure --prefix=/usr/local/modules --modulefilesdir=/opt/modules/
sudo make -j8
sudo make install

## configuration
sudo tee /etc/profile.d/modules.sh > /dev/null << 'EOF'
#----------------------------------------------------------------------#
# system-wide profile.modules #
# Initialize modules for all sh-derivative shells #
#----------------------------------------------------------------------#

trap "" 1 2 3

MODULES=/usr/local/modules

case "$0" in
-bash|bash|*/bash) . $MODULES/init/bash ;;
-ksh|ksh|*/ksh) . $MODULES/init/ksh ;;
-sh|sh|*/sh) . $MODULES/init/sh ;;
*) . $MODULES/init/sh ;; # default for scripts
esac

trap - 1 2 3
EOF

or

sudo ln -s /usr/local/modules/init/profile.sh /etc/profile.d/modules.sh

### modulefile
sudo vi /opt/modules/cuda-10.1-cudnn-v7.6.4
#############################################################
#%Module1.0
##
## cuda-10.1-cudnn-v7.6.4 modulefile
##
proc ModulesHelp { } {
    puts stderr "cuda-10.1-cudnn-v7.6.4"
}

module-whatis "Name: cuda-10.1-cudnn-v7.6.4"

prepend-path PATH /usr/local/cuda-10.1-cudnn-v7.6.4/bin
prepend-path LD_LIBRARY_PATH /usr/local/cuda-10.1-cudnn-v7.6.4/lib64:/usr/local/cuda-10.1-cudnn-v7.6.4/lib
#############################################################

## gcc/g++ alternative
sudo apt-get install gcc-x.x g++-x.x
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 <priority>
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 <priority>

### alternative simultaneously
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 4 --slave /usr/bin/g++ g++ /usr/bin/g++-4.8

## cuda/cudnn
sudo ./NVIDIA-Linux-x86_64-430.64.run --no-opengl-files

sudo sh cuda_10.1.243_418.87.00_linux.run --silent --toolkit --toolkitpath=/usr/local/cuda-10.1-cudnn-v7.6.4

sudo sh cuda_10.0.130_410.48_linux --silent --toolkit --toolkitpath=/usr/local/cuda-10.0-cudnn-7.4.2


### cuda patch
sudo sh ./cuda_9.0.176.1_linux-run --silent --accept-eula --installdir=/usr/local/cuda-9.0-cudnn-7.0.5

## cuda9.0 nccl
tar -xvf nccl_2.5.6-1+cuda9.0_x86_64.txz
cd nccl_2.5.6-1+cuda9.0_x86_64
sudo cp nccl_2.5.6-1+cuda9.0_x86_64/include/nccl.h /usr/local/cuda-9.0-cudnn-7.0.5/include
sudo cp nccl_2.5.6-1+cuda9.0_x86_64/lib/libnccl* /usr/local/cuda-9.0-cudnn-7.0.5/lib64
sudo chmod a+r /usr/local/cuda-9.0-cudnn-7.0.5/include/nccl.h /usr/local/cuda-9.0-cudnn-7.0.5da/lib64/libnccl*

tar -xvzf cudnn-10.1-linux-x64-v7.6.4.38.tar.gz

sudo cp -arp cudnn-10.1-linux-x64-v7.6.4.38/include/* /usr/local/cuda-10.1-cudnn-v7.6.4/include/
sudo cp -arp cudnn-10.1-linux-x64-v7.6.4.38/lib64/* /usr/local/cuda-10.1-cudnn-v7.6.4/lib64/

tar -xvf nccl_2.7.5-1+cuda10.1_x86_64.txz
cd nccl_2.7.5-1+cuda10.1_x86_64
sudo cp -R * /usr/local/cuda-10.1-cudnn-v7.6.4/targets/x86_64-linux
sudo ldconfig
```

## nvidia-persistenced mode

```bash
cd /usr/share/doc/NVIDIA_GLX-1.0/sample
sudo tar -xvf nvidia-persistenced-init.tar.bz2
sudo ./install.sh

sudo systemctl status nvidia-persistenced.service
sudo systemctl enable nvidia-persistenced.service

```

### nccl version check

```python
import torch
torch.cuda.is_available()
torch.version.cuda
torch.backends.cudnn.version()
torch.cuda.nccl.version()
```

### redirect log to files

```bash
(stdout to file) COMMAND 1> file
(stderr to file) COMMAND 2> error
(stdout/stderr to seperate file) COMMAND 2> error.txt 1> output.txt
(redirect stderr to stdout) COMMAND > file 2>&1
```

## python snippets

```python
## dir finding
print('\n'.join([s for s in dir(np) if s.find('_c') >= 0]))

## module reload
from imp import reload

## for training
from tqdm import trange
t = trange(num_epochs)
t.set_description('epoch %i'%epoch)
t.set_postfix(train_loss = avg_train_loss, val_loss = avg_val_loss)
time.sleep(0.01)

## graph option
import matplotlib.pyplot as plt
import seaborn as sns
colors = ['#34495e','#2ecc71','#3498db','#FFFF00', '#e74c3c','#a9a9a9']
sns.set(style="ticks", color_codes=True)
plt.style.use('seaborn-darkgrid')

## get index from list by condition
def indices(list, filtr=lambda x: bool(x)):
  return [i for i,x in enumerate(list) if filtr(x)]

## consecutive itertools
from itertools import islice, tee

def nwise(iterable, n=2):
    iters = tee(iterable, n)
    for i, it in enumerate(iters):
        next(islice(it, i, i), None)
    return zip(*iters)

## basic pandas option
import os, pickle, glob, re, json
import dill
import numpy as np
import pandas as pd
pd.set_option("max_colwidth", 4000)
import copy
import time

from collections import Counter
from tqdm import tqdm
import argparse

from sklearn.model_selection import train_test_split

from util import (get_dataframe_from_packet_data,
                  make_readable,
                  extract_pattern,
                  get_examples,
                  get_max_len,
                  get_hidden_states,
                  get_sent_vec,
#                   get_ics_vec,
                  get_distil_vec, 
                  format_time)

import logging
from datetime import datetime, timezone, timedelta
import pytz
def timetz(*args):    return datetime.now(tz).timetuple()

logger = logging.getLogger()
tz = pytz.timezone('Asia/Seoul') # UTC, Asia/Seoul, Europe/Berlin
logging.Formatter.converter = timetz
logging.basicConfig(format='%(asctime)s - %(message)s', datefmt = '%Y-%m-%d %H:%M:%S', level=logging.INFO)

## custome path insert
import sys
sys.path.insert(0, '/the/folder/path/name-package/')

```

## Docker configuration

### install the docker enginer through curl

```bash
curl -fsSL https://get.docker.com >> docker.sh
sudo sh ./docker.sh
sudo usermod -aG docker $(whoami)

```

## git command

### git push authentication failed

```bash
git remote -v                                       ## origin name 확인
git remote remove origin                            ## origin 제거
git remote add origin git@github.com:user/repo.git  ## origin 재설정
```

## vscode configuration

### run a file on current open directory

- add the configuration : ctrl + shift + p -> terminal.integrated.cwd -> ${fileDirname}
- add the configuration : ctrl + shift + p -> "Debug Open launch.json" -> ${fileDirname}
