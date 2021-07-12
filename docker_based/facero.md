## version check

```bash
nvcc --version
cat /etc/alternatives/libcudnn | grep -i 'cudnn_major\|cudnn_minor\|cudnn_patchlevel'
```

## container instance

```bash
groupadd -g 10000 researchers
useradd -u 10002 -g 10000 facero01 -d /data/facero/facero01 -s /bin/bash
useradd -u 10003 -g 10000 facero02 -d /data/facero/facero02 -s /bin/bash
useradd -u 10004 -g 10000 facero03 -d /data/facero/facero03 -s /bin/bash

NV_GPU='0, 1, 2, 3' nvidia-docker run -d -it \
                                      --user root \
                                      --hostname facero.com \
                                      --memory="100G" \
                                      --memory-swap=0 \
                                      --shm-size=2G \
                                      --cpus="4" \
                                      -p 12222:22 \
                                      -p 18888:8888 \
                                      -p 16006:6006 \
                                      -p 18000:8000 \
                                      -p 18989:8989 \
                                      -p 13389:3389 \
                                      -e NB_UID=10002 \
                                      -e NB_GID=10000 \
                                      -v /data/facero/facero01:/home/facero \
                                      --name facero01 \
                                      lucas.ku/facerocv:0.1

NV_GPU='4, 5' nvidia-docker run -d -it \
                                      --user root \
                                      --hostname facero.com \
                                      --memory="100G" \
                                      --memory-swap=0 \
                                      --shm-size=2G \
                                      --cpus="4" \
                                      -p 22222:22 \
                                      -p 28888:8888 \
                                      -p 26006:6006 \
                                      -p 28000:8000 \
                                      -p 28989:8989 \
                                      -p 23389:3389 \
                                      -e NB_UID=10003 \
                                      -e NB_GID=10000 \
                                      -v /data/facero/facero02:/home/facero \
                                      --name facero02 \
                                      lucas.ku/facerocv:0.1

NV_GPU='6' nvidia-docker run -d -it \
                                      --user root \
                                      --hostname facero.com \
                                      --memory="100G" \
                                      --memory-swap=0 \
                                      --shm-size=2G \
                                      --cpus="4" \
                                      -p 42222:22 \
                                      -p 48888:8888 \
                                      -p 46006:6006 \
                                      -p 48000:8000 \
                                      -p 48989:8989 \
                                      -p 43389:3389 \
                                      -e NB_UID=10004 \
                                      -e NB_GID=10000 \
                                      -v /data/facero/facero03:/home/facero \
                                      --name facero03 \
                                      lucas.ku/facerocv:0.1
```
