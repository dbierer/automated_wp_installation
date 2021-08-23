#!/bin/bash
# To run the container locally you need to add an entry $DNS.local to your local "hosts" file
. ./secrets.sh
DIR=`pwd`
export USAGE="Usage: admin.sh up|down|build|init|shell|ls [--no-backup]"
if [[ -z "$1" ]]; then
    echo $USAGE
    exit 1
fi
if [[ "$1" = "up" || "$1" = "start" ]]; then
    cp docker-compose.yml.dist docker-compose.yml
    sed -i "s/=DNS=/$DNS/g" docker-compose.yml
    sed -i "s/=CONTAINER=/$CONTAINER/g" docker-compose.yml
    sed -i "s/=CONTAINER_IP=/$CONTAINER_IP/g" docker-compose.yml
    sed -i "s/=CONTAINER_SUBNET=/$CONTAINER_SUBNET/g" docker-compose.yml
    docker-compose up -d
    if [[ -z "$2" ]]; then
        docker exec $CONTAINER /bin/bash -c "/tmp/restore.sh"
    fi
    # Uncomment these lines if you want to run container locally:
    # docker exec $CONTAINER /bin/bash -c "cp $WP_DIR/bedrock/.env $WP_DIR/bedrock/env_bak"
    # docker exec $CONTAINER /bin/bash -c "sed -i 's/https:/http:/g' $WP_DIR/bedrock/.env"
    # docker exec $CONTAINER /bin/bash -c "sed -i 's/\.com/\.local/g' $WP_DIR/bedrock/.env"
elif [[ "$1" = "down" || "$1" = "stop" ]]; then
    # Uncomment this line if you want to run container locally:
    # docker exec $CONTAINER /bin/bash -c "cp $WP_DIR/bedrock/env_bak $WP_DIR/bedrock/.env "
    if [[ -z "$2" ]]; then
        docker exec $CONTAINER /bin/bash -c "/tmp/backup.sh"
    fi
    docker-compose down
    sudo chown -R $USER:$USER *
elif [[ "$1" = "ls" ]]; then
    docker container ls
elif [[ "$1" = "build" ]]; then
    cp docker-compose.yml.dist docker-compose.yml
    sed -i "s/=DNS=/$DNS/g" docker-compose.yml
    sed -i "s/=CONTAINER=/$CONTAINER/g" docker-compose.yml
    sed -i "s/=CONTAINER_IP=/$CONTAINER_IP/g" docker-compose.yml
    sed -i "s/=CONTAINER_SUBNET=/$CONTAINER_SUBNET/g" docker-compose.yml
    docker-compose build
elif [[ "$1" = "init" ]]; then
    if [[ -z ${CONTAINER} ]]; then
        echo "Unable to locate running container"
    else
        docker exec $CONTAINER /bin/bash -c "/etc/init.d/mysql start"
        docker exec $CONTAINER /bin/bash -c "/etc/init.d/php-fpm start"
        docker exec $CONTAINER /bin/bash -c "/etc/init.d/httpd start"
    fi
elif [[ "$1" = "shell" ]]; then
    if [[ -z ${CONTAINER} ]]; then
        echo "Unable to locate running container: $CONTAINER"
    else
        docker exec -it $CONTAINER /bin/bash
    fi
else
    echo $USAGE
    exit 1
fi
