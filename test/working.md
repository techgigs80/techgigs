## working md

docker run -d -e ROOT=TRUE -e USER=user01 -e USERID=1002 -e GROUPID=1001 -e PASSWORD=q1w2e3r4! -p 10000:8787 -v /home/data/workspace/graph:/home/user01/graph -v /home/data/workspace/user01:/home/user01 -v /home/data/workspace/data:/home/user01/data --name rstudio01 rocker/rstudio:3.4.2
