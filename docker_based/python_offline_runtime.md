# [Centos7] install python3 and move virtualenv folder to another machine

## update yum repository

```bash
yum update -y
yum install -y gcc openssl-devel bzip2-devel libffi libffi-devel make wget
yum install --downloadonly --downloaddir=/root/localinstall python3

yum localinstall *
```

## install python3

```bash
wget https://www.python.org/ftp/python/3.6.8/Python-3.6.8.tgz
tar xvzf Python-3.6.8.tgz && cd Python-3.6.8
./configure --enable-optimization && make -j16
make altinstall

# add symbolic link
ln -s /usr/local/bin/python3.6 /usr/bin/python3
ln -s /usr/local/lib/python3.6/ /usr/lib/python3.6
```

## install virtualenv

```bash
# pbr pacakge 5.4.3
wget https://files.pythonhosted.org/packages/99/f1/7807d3409c79905a907f1c616d910c921b2a8e73c17b2969930318f44777/pbr-5.4.3.tar.gz

# virtualenv 16.7.2
wget https://files.pythonhosted.org/packages/a9/8a/580c7176f01540615c2eb3f3ab5462613b4beac4aa63410be89ecc7b7472/virtualenv-16.7.2.tar.gz

# virtualenv-clone 0.5.3
wget https://files.pythonhosted.org/packages/d7/a7/08b88808c409722361459f1ae24474530d83593d6ded346f1d3649326838/virtualenv-clone-0.5.3.tar.gz

# stevedore 1.30.1
wget https://files.pythonhosted.org/packages/dc/22/a8fec083ae5214d5eb847537b1f28169136e989b56561f472dd2cbe465cd/stevedore-1.30.1.tar.gz

# virtualenvwrapper 4.8.4
wget https://files.pythonhosted.org/packages/c1/6b/2f05d73b2d2f2410b48b90d3783a0034c26afa534a4a95ad5f1178d61191/virtualenvwrapper-4.8.4.tar.gz

easy_install-3.6 pip # only at compiled python
pip install --user pbr-5.4.3.tar.gz
pip install --user virtualenv-16.7.2.tar.gz
pip install --user virtualenv-clone-0.5.3.tar.gz
pip install --user stevedore-1.30.1.tar.gz
pip install --user virtualenvwrapper-4.8.4.tar.gz

find / -name 'virtualenvwrapper.sh' -ls
```

## add the virtualenvwrapper shell in .bashrc

```bash
export PATH=~/.local/bin:$PATH
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
export WORKON_HOME=/root/.virtualenvs
. /root/.local/bin/virtualenvwrapper.sh
```

## copy the whole virtualenv

```bash
cd $HOME/.virtualenvs
tar -cvzf p_infra.tar.gz p_infra
```

## rename all environment path on remote machine

```bash
# on remote machine
cd $HOME/.virtualenvs
tar -xvzf p_infra.tar.gz

grep "/home/roki/*" p_infra/ -R
# (output list for changes)
# make sed bash script for them
```
