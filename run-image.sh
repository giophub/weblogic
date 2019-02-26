#!/bin/sh

# get current path
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  TARGET="$(readlink "$SOURCE")"
  if [[ $TARGET == /* ]]; then
    echo "SOURCE '$SOURCE' is an absolute symlink to '$TARGET'"
    SOURCE="$TARGET"
  else
    DIR="$( dirname "$SOURCE" )"
    echo "SOURCE '$SOURCE' is a relative symlink to '$TARGET' (relative to '$DIR')"
    SOURCE="$DIR/$TARGET" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
  fi
done
echo "SOURCE is '$SOURCE'"
RDIR="$( dirname "$SOURCE" )"
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
if [ "$DIR" != "$RDIR" ]; then
  echo "DIR '$RDIR' resolves to '$DIR'"
fi
echo "DIR is '$DIR'"

# set the external docker volume
VOLUME=$DIR/volume
echo docker external volume: $VOLUME

# set write privileges when execute with docker
chown 1000:1000 -R $VOLUME
chmod 777 -R $VOLUME

# docker run -d --name wlsadmin --hostname wlsadmin -p 7001:7001 --env-file ./container-scripts/domain.properties -e ADMIN_PASSWORD=weblogic01 -v /dvol:/u01/oracle/user_projects custom_domain

# docker run -d --name wl-gp-generic --hostname wlsadmin -p 7001:7001 --env-file ./container-scripts/domain.properties -e ADMIN_PASSWORD=weblogic01 -v /dvol/oracle/weblogic:/u01/oracle/user_projects weblogic-gp-generic:12.1.3
# docker run --name wl-gp-generic --hostname wlsadmin -p 7001:7001 -p 7002:7002 --env-file ./container-scripts/domain.properties -e DOMAIN_NAME=ssl_domain -e ADMIN_PASSWORD=weblogic01 -v $VOLUME:/u01/oracle/user_projects weblogic-gp-generic:12.1.3
docker run --name wl-gp-generic-ssl -p 7001:7001 -p 7002:7002 --env-file ./container-scripts/domain.properties -v $VOLUME:/u01/oracle/user_projects giodocker/weblogic:12.1.3-generic-ssl