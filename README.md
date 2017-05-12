# ot-recorder created based on linux alpine, inside mqtt server and ssh access - maping shared dirs


# BUILD
USE TAG for RPI - :armhf
docker build --no-cache=true --compress=true -t robowntracks/owntracks-alpine:amd64 .

# Container create and run 
USE TAG for RPI - :armhf
docker run -ti  --name=ot-recorder -p 8083:8083 -p 1883:1883 robowntracks/owntracks-alpine:amd64 
for background add option -d
# sharing with docker host 
add option

-v /ot-recorder/htdocs:/usr/share/ot-recorder/htdocs -v /ot-recorder/store:/var/lib/ot-recorder/store 

where dir before : is host created dir and after : there is directory inside docker

You should remember that all structure of recorder for http and store must be copied from docker container before start / stop:

docker cp [OPTIONS] CONTAINER:SRC_PATH DEST_PATH|-
docker cp [OPTIONS] SRC_PATH|- CONTAINER:DEST_PATH

https://docs.docker.com/engine/reference/commandline/cp/
