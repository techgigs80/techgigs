# configuration Rstudio based on rocker/rstudio

## docker configure

```bash
docker run -d 
  -p 10000:8787                               # host port : internel port
  -e ROOT=TRUE                                # for install package in container
  -e USER=user01                              # user name for container
  -e USERID=1002                              # host userid for container user
  -e GROUPID=1001                             # host userid for container user
  -e UMASK=022
  -e PASSWORD='q1w2e3r4!'                     # password for rstuio user
  -v /home/data/workspace:/home/user01        # host volume : internel volume
  --name rstudio01                            # container name
  rocker/rstudio:3.4.2                        # image name
```