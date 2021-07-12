# Install nvidia-docker for gpu computing

## Remove old docker-ce

```bash
sudo apt remove docker docker-engine docker.io
```

## Install essential pacakges

```bash
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
```

## Add official GPG key of docker and add fingerprint

```bash
## Add the key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

## Verifying the key
sudo apt-key fingerprint 0EBFCD88
```

## Add repository for the docker

```bash
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update --fix-missing
```

## Install the docker-ce (community)

```bash
sudo apt-get install docker-ce
```

## Configure the docker storage

```bash
sudo systemctl stop docker.service
sudo mv /var/lib/docker $[PLACE_YOU_WANT]
sudo ln -s $[PLACE_YOU_WANT] /var/lib/

## Give the permission to the user for w/o 'sudo'
## restart required
sudo usermod -aG docker ${USER}
sudo systemctl start docker.service

## Testing the docker engine
docker run hello-world

## Delete all testing images
docker stop $(docker ps -a -q) (for stopping containers)
docker rm $(docker ps -a -q) (for removing the containers)
```

## Install the nvidia docker

```bash
## for removing the existing GPU based containers
docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f
sudo apt-get purge -y nvidia-docker
```

## Add the nvidia-docker repository and install the nvidia-docker

```bash
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update --fix-missing

## install nvidia-docker
sudo apt install nvidia-docker2
```

## Build the jupyter docker images from nvidia-docker images and create the container

```bash
## build up
nvidia-docker build -f notebook.dockerfile -t lucas.ku/jupyterlab:0.1 .

## configure co-working folder and user
useradd -g [GROUP_ID_YOU_CREATED] [ACCOUNT_YOU_WANT]
usermod -aG [GROUP_YOU_CREATED] [ACCOUNT_YOU_WANT]
mkdir -p [CO-WORK_FOLDER_YOU_WANT]
chmod 775 [CO-WORK_FOLDER_YOU_WANT]

## create the container
nvidia-docker network create [DOCKER_NET_NAME]
NV_GPU='0,1,3,4'  nvidia-docker run -d \
                                    --user root \
                                    --hostname [HOST_YOU_WANT] \
                                    --network [DOCKER_NET_NAME] \
                                    -p [JUPYTER_PORT]:8888 \
                                    -p [TENSORBOARD_PORT]:6006 \
                                    -p [VISDOM_PORT]:8097 \
                                    -e NB_UID=[ACCOUNT_ID] \
                                    -e NB_GID=[GROUP_ID_YOU_CREATED] \
                                    -v [WORK_FOLDER_YOU_WANT]:/home/jovyan/work/ \
                                    --name [NAME_YOU_WANT] \
                                    lucas.ku/jupyter-lab:0.1

## visdom configuration
git clone https://github.com/facebookresearch/visdom.git [FOLDER_YOU_WANT]/visdom
cd [FOLDER_YOU_WANT]/visdom
mkdir ~/.visdom
pip install .

python -m visdom.server --hostname 127.0.0.1 -env_path "~/.visdom/" -port 8097
# or outside of container
docker exec -it -u jovyan [CONTAINER_NAME] /bin/bash -c "source [VIRTUALENV_PATH]/.virtualenvs/[ENV_NAME]/bin/activate;python -m visdom.server --hostname 127.0.0.1 -env_path ~/.visdom/ -port 8097"

## for make virtualenv
nvidia-docker exec -it -u jovyan note bash
mkvirtualenv -p python [ENV_NAME]
python -m ipykernel install --user --name=p_infra
```

## About CNTK container

```bash
NV_GPU='0,1,3,4'  nvidia-docker run -it -p 30000:8888 \
                                    -e NB_UID=$(id -u) \
                                    -e NB_GID=$(id -g) \
                                    -v /home/roki/shared/study/MS_AI/:/cntk/Tutorials/MS_AI/ \
                                    --name cntk20 mcr.microsoft.com/cntk/release:2.0.rc3-gpu-python3.5-cuda8.0-cudnn5.1
nvidia-docker exec -it cntk20 \
                      bash -c "source /cntk/activate-cntk && jupyter-notebook --no-browser --port=8888 --ip=0.0.0.0 --notebook-dir=/cntk/Tutorials --allow-root"
```
