# Configure the jupyter notebook on ubuntu

## virtualenv configuration

- Install virtualenv packages

```bash
    sudo -H pip install virtualenv virtualenvwrapper
```

- Add virtualenvs env and setting

```bash
cat>>~/.bashrc<<EOF
export WORKON_HOME=${HOME}.virtualenvs
. /usr/local/bin/virtualenvwrapper.sh
EOF
```

- Install jupyter and install

```bash
  pip install jupyter
```

- Generate the jupyter configure file

```bash
jupyter notebook --generate-config

(output looks like)
Writing default config to: [HOME_FOLDER]/.jupyter/jupyter_notebook_config.py
```

- Change for the usage

```bash
sed -i "s/#c.NotebookApp.ip = 'localhost'/c.NotebookApp.ip = '0.0.0.0'/g" ${HOME}/.jupyter/jupyter_notebook_config.py
sed -i "s/#c.NotebookApp.notebook_dir = u''/c.NotebookApp.notebook_dir = u'[FOLDER_YOU_WANT]'/g" ${HOME}/.jupyter/jupyter_notebook_config.py
sed -i "s/#c.NotebookApp.port = 8888/c.NotebookApp.port = [PORT_YOU_WANT]/g" ${HOME}/.jupyter/jupyter_notebook_config.py
sed -i "s/#c.NotebookApp.open_browser = True/c.NotebookApp.open_browser = False/g" ${HOME}/.jupyter/jupyter_notebook_config.py
```

- Add access password for Notebook

```bash
  jupyter notebook password
```

- add useful alias for the jupyter

```bash
alias jupyter_on='jupyter lab 2>~/jupyter.log&'
JUPYTER_ID=`ps aux | grep -i 'jupyter-lab' | grep $(whoami) | head -1 | awk '{print $2}'`
alias jupyter_off='kill -9 $JUPYTER_ID'
```

## Create python virtualenv

```bash
mkvirtualenv -p python3.6 [ENV_NAME]
workon [ENV_NAME]
([ENV_NAME]) python -m ipykernel install --user --name=[ENV_NAME]
```

## extra

```bash
jupyter kernelspec list   # check the ipkernel list
jupyter kernelspec remove # remove the ipkernel
```
